#!/usr/bin/env bash

# Prints the path to the roc binary of the given version, downloading it into
# roc_nightly/<version>/ first if needed.
# The version is a nightly tag or a release as pinned in an example header.
# Usage: ./ci_scripts/get_roc.sh nightly-2026-10-09-258ab27
#        ./ci_scripts/get_roc.sh 0.1.0-RC1

set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: get_roc.sh VERSION" >&2
  exit 1
fi

readonly tag="$1"

case "$(uname -s)-$(uname -m)" in
  Linux-x86_64) arch="linux_x86_64" ;;
  Linux-aarch64 | Linux-arm64) arch="linux_arm64" ;;
  Darwin-arm64) arch="macos_apple_silicon" ;;
  Darwin-x86_64) arch="macos_x86_64" ;;
  MINGW*-x86_64 | MSYS*-x86_64) arch="windows_x86_64" ;;
  *) echo "unsupported platform: $(uname -sm)" >&2; exit 1 ;;
esac

# Windows builds are zip archives with roc.exe.
if [ "$arch" = "windows_x86_64" ]; then
  readonly ext="zip" exe="roc.exe"
else
  readonly ext="tar.gz" exe="roc"
fi

if [[ "$tag" =~ ^nightly-([0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9a-f]+)$ ]]; then
  readonly date_sha="${BASH_REMATCH[1]}"
  readonly archive="roc_nightly-$arch-$date_sha"
  readonly url="https://github.com/roc-lang/nightlies/releases/download/$tag/$archive.$ext"
elif [[ "$tag" =~ ^[0-9]+\.[0-9]+\.[0-9]+(-[A-Za-z0-9.]+)?$ ]]; then
  # A pin like 0.1.0-RC1 is the release 0.1.0_RC1, `roc version` prints it with an underscore.
  readonly release="${tag//-/_}"
  readonly archive="roc-$arch-$release"
  readonly url="https://github.com/roc-lang/roc/releases/download/$release/$archive.$ext"
else
  echo "expected a nightly tag like nightly-2026-10-09-258ab27 or a release like 0.1.0, got: $tag" >&2
  exit 1
fi

readonly repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly dir="$repo_root/roc_nightly/$tag"
readonly roc="$dir/$archive/$exe"

if [ ! -x "$roc" ]; then
  # Extract into a temporary directory so an interrupted download is never mistaken for a complete one.
  mkdir -p "$repo_root/roc_nightly"
  tmp="$(mktemp -d "$repo_root/roc_nightly/.tmp.XXXXXX")"
  trap 'rm -rf "$tmp"' EXIT

  if [ "$ext" = "zip" ]; then
    curl --fail --silent --show-error --location --retry 5 --retry-all-errors --output "$tmp/roc.zip" "$url"
    unzip -q "$tmp/roc.zip" -d "$tmp"
    rm "$tmp/roc.zip"
  else
    curl --fail --silent --show-error --location --retry 5 --retry-all-errors "$url" | tar -xz -C "$tmp"
  fi

  rm -rf "$dir"
  mv "$tmp" "$dir"
  trap - EXIT
fi

echo "$roc"
