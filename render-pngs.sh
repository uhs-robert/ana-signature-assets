#!/usr/bin/env bash
# Renders the signature's PNGs into assets/: every SVG in svg-src/, plus the
# script-font name. SVG output pixel size comes from each SVG's width/height
# attributes (2x the size the signature displays).
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
svg_dir="$repo_root/svg-src"
png_dir="$repo_root/assets"

name_text="Ana Hill"
name_font="$repo_root/fonts/Parisienne-Regular.ttf"
name_point_size=106
name_padding_px=7
ink_color="#2B4A7F"
background_color="#F7F1E6"

render_svg() {
  local svg_path=$1 png_path=$2
  mkdir -p "$(dirname "$png_path")"
  rsvg-convert "$svg_path" -o "$png_path"
  echo "${png_path#"$repo_root"/}"
}

for svg_path in "$svg_dir"/divider-*.svg; do
  render_svg "$svg_path" "$png_dir/$(basename "$svg_path" .svg).png"
done

for svg_path in "$svg_dir"/icons/*.svg; do
  render_svg "$svg_path" "$png_dir/icon-$(basename "$svg_path" .svg).png"
done

# The name is set from the bundled font file rather than an installed font so
# the output doesn't depend on what the machine has. -strip drops ImageMagick's
# timestamp chunks, which would otherwise change the PNG bytes on every run.
name_png_path="$png_dir/name-parisienne.png"
magick -background "$background_color" -fill "$ink_color" \
  -font "$name_font" -pointsize "$name_point_size" label:"$name_text" \
  -fuzz 5% -trim +repage \
  -bordercolor "$background_color" -border "$name_padding_px" \
  -strip "$name_png_path"
echo "${name_png_path#"$repo_root"/} ($(magick identify -format '%wx%h' "$name_png_path"); keep the <img> width/height in index.html at the same aspect ratio)"
