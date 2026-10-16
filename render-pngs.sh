#!/usr/bin/env bash
# Renders every SVG in svg-src/ to its PNG in assets/. Output pixel size comes
# from each SVG's width/height attributes (2x the size the signature displays).
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
svg_dir="$repo_root/svg-src"
png_dir="$repo_root/assets"

render() {
  local svg_path=$1 png_path=$2
  mkdir -p "$(dirname "$png_path")"
  rsvg-convert "$svg_path" -o "$png_path"
  echo "${png_path#"$repo_root"/}"
}

for svg_path in "$svg_dir"/divider-*.svg; do
  render "$svg_path" "$png_dir/$(basename "$svg_path" .svg).png"
done

for svg_path in "$svg_dir"/icons/*.svg; do
  render "$svg_path" "$png_dir/icon-$(basename "$svg_path" .svg).png"
done

for svg_path in "$svg_dir"/icon-sets/*/*.svg; do
  set_name=$(basename "$(dirname "$svg_path")")
  render "$svg_path" "$png_dir/icons-$set_name/icon-$(basename "$svg_path" .svg).png"
done
