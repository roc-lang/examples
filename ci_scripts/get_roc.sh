#!/usr/bin/env bash

# Prints the path to the roc binary of the given nightly, downloading it into
# roc_nightly/<tag>/ first if needed.
# Usage: ./ci_scripts/get_roc.sh nightly-2026-10-09-258ab27

set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: get_roc.sh NIGHTLY_TAG" >&2
  exit 1
fi

readonly tag="$1"

if [[ ! "$tag" =~ ^nightly-([0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9a-f]+)$ ]]; then
  echo "expected a nightly release tag like nightly-2026-10-09-258ab27, got: $tag" >&2
  exit 1
fi
readonly date_sha="${BASH_REMATCH[1]}"

case "$(uname -s)-$(uname -m)" in
  Linux-x86_64) arch="linux_x86_64" ;;
  Linux-aarch64 | Linux-arm64) arch="linux_arm64" ;;
  Darwin-arm64) arch="macos_apple_silicon" ;;
  Darwin-x86_64) arch="macos_x86_64" ;;
  *) echo "unsupported platform: $(uname -sm)" >&2; exit 1 ;;
esac

readonly repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly dir="$repo_root/roc_nightly/$tag"
readonly roc="$dir/roc_nightly-$arch-$date_sha/roc"

if [ ! -x "$roc" ]; then
  # Extract into a temporary directory so an interrupted download is never mistaken for a complete one.
  mkdir -p "$repo_root/roc_nightly"
  tmp="$(mktemp -d "$repo_root/roc_nightly/.tmp.XXXXXX")"
  trap 'rm -rf "$tmp"' EXIT

  url="https://github.com/roc-lang/nightlies/releases/download/$tag/roc_nightly-$arch-$date_sha.tar.gz"
  curl --fail --silent --show-error --location --retry 5 --retry-all-errors "$url" | tar -xz -C "$tmp"

  rm -rf "$dir"
  mv "$tmp" "$dir"
  trap - EXIT
fi

echo "$roc"
