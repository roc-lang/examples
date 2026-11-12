#!/usr/bin/env bash

# Prints the path to the elm binary, downloading it into elm_compiler/<version>/ first if needed.
# Keep the version in sync with "elm-version" in examples/ElmWebApp/frontend/elm.json.
# Usage: ./ci_scripts/get_elm.sh

set -euo pipefail

readonly version="0.19.3"

# sha256 checksums of the release assets, from https://github.com/elm/compiler/releases/tag/0.19.3
case "$(uname -s)-$(uname -m)" in
  Linux-x86_64) asset="linux-x64" sha256="d11702b31577ed8b720b9d81c52c8a19a52b72b1fcfadef0fcad92f21798c58a" ;;
  Linux-aarch64 | Linux-arm64) asset="linux-arm" sha256="4d22c4d10f89e482d3554b7af4f6527f8a05e4d82648a07b23f1f211495b5d24" ;;
  Darwin-arm64) asset="mac-arm" sha256="a426e47d14cba0588aa81475adc32ba24bbf045209d0c560d0a89a5c4f3c34d0" ;;
  Darwin-x86_64) asset="mac-x64" sha256="4a9c5578e53c4feb55b91c8ee9a0f46da9913414c6303d1c55add0d3abcd9921" ;;
  *) echo "unsupported platform: $(uname -sm)" >&2; exit 1 ;;
esac

readonly repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
readonly dir="$repo_root/elm_compiler/$version"
readonly elm="$dir/elm"

if [ ! -x "$elm" ]; then
  # Download into a temporary directory so an interrupted download is never mistaken for a complete one.
  mkdir -p "$repo_root/elm_compiler"
  tmp="$(mktemp -d "$repo_root/elm_compiler/.tmp.XXXXXX")"
  trap 'rm -rf "$tmp"' EXIT

  url="https://github.com/elm/compiler/releases/download/$version/elm-$version-$asset.gz"
  curl --fail --silent --show-error --location --retry 5 --retry-all-errors --output "$tmp/elm.gz" "$url"
  echo "$sha256  $tmp/elm.gz" | shasum -a 256 --check --status || {
    echo "checksum mismatch for $url" >&2
    exit 1
  }
  gunzip "$tmp/elm.gz"
  chmod +x "$tmp/elm"

  rm -rf "$dir"
  mv "$tmp" "$dir"
  trap - EXIT
fi

echo "$elm"
