#!/bin/sh
# Download the official emhcl release once, then run it.
# https://github.com/event-modeling-hcl/eventmodeling-hcl
set -eu
VERSION=0.16.0
DIR=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
BIN="$DIR/emhcl"
if [ ! -x "$BIN" ]; then
  if command -v emhcl >/dev/null 2>&1; then
    exec emhcl "$@"
  fi
  os=$(uname -s | tr '[:upper:]' '[:lower:]')
  arch=$(uname -m)
  case "$arch" in
    x86_64|amd64) arch=amd64 ;;
    aarch64|arm64) arch=arm64 ;;
    *) echo "emhcl.sh: unsupported architecture $arch" >&2; exit 2 ;;
  esac
  case "$os" in
    linux|darwin) ;;
    *) echo "emhcl.sh: unsupported OS $os" >&2; exit 2 ;;
  esac
  url="https://github.com/event-modeling-hcl/eventmodeling-hcl/releases/download/v${VERSION}/emhcl_${VERSION}_${os}_${arch}.tar.gz"
  tmp=$(mktemp -d)
  curl -fsSL "$url" -o "$tmp/emhcl.tar.gz"
  tar -xzf "$tmp/emhcl.tar.gz" -C "$tmp" --no-same-owner 2>/dev/null || tar -xzf "$tmp/emhcl.tar.gz" -C "$tmp" || true
  if [ ! -f "$tmp/emhcl" ]; then
    echo "emhcl.sh: download unpacked no binary from $url" >&2
    exit 1
  fi
  install -m 755 "$tmp/emhcl" "$BIN"
  rm -rf "$tmp"
fi
exec "$BIN" "$@"
