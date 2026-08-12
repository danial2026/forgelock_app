#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# Convert screenshots to Myket publishing standards:
#   - at least 3 images
#   - max width/height 3000 px
#   - aspect ratio 16:9 (landscape) or 9:16 (portrait), e.g. 1600x900
#   - max file size 3 MB
#
# Images are CENTER-CROPPED to the target ratio at their native resolution
# (cropped, never upscaled, never padded).
#
# Usage:
#   scripts/myket_screenshots.sh [SRC_DIR] [OUT_DIR]
#
# Env overrides:
#   FFMPEG=/path/to/ffmpeg    ffmpeg binary location
#   FFPROBE=/path/to/ffprobe  ffprobe binary location
#
# Outputs:
#   PNG when it fits under 3 MB, otherwise JPEG with quality reduced until <= 3 MB.
# -----------------------------------------------------------------------------
set -euo pipefail
cd "$(dirname "$0")/.."

FFMPEG="${FFMPEG:-/opt/homebrew/bin/ffmpeg}"
FFPROBE="${FFPROBE:-/opt/homebrew/bin/ffprobe}"

SRC_DIR="${1:-screenshot}"
OUT_DIR="${2:-screenshot/myket}"

MAX_BYTES=$((3 * 1024 * 1024))
MIN_COUNT="${MIN_COUNT:-3}"

if ! command -v "$FFMPEG" >/dev/null 2>&1; then
  echo "ERROR: ffmpeg not found at $FFMPEG (install with: brew install ffmpeg)" >&2
  exit 1
fi
if ! command -v "$FFPROBE" >/dev/null 2>&1; then
  echo "ERROR: ffprobe not found at $FFPROBE" >&2
  exit 1
fi

INPUTS=()
while IFS= read -r f; do
  INPUTS+=("$f")
done < <(find "$SRC_DIR" -maxdepth 1 -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \) | sort)

if [ "${#INPUTS[@]}" -lt "$MIN_COUNT" ]; then
  echo "ERROR: Myket requires at least $MIN_COUNT screenshots, found ${#INPUTS[@]} in $SRC_DIR" >&2
  exit 1
fi

mkdir -p "$OUT_DIR"

pass=0; fail=0

for img in "${INPUTS[@]}"; do
  name="$(basename "$img")"
  stem="${name%.*}"
  out_base="$OUT_DIR/$stem"

  dims="$("$FFPROBE" -v error -select_streams v:0 -show_entries stream=width,height -of csv=p=0 "$img")"
  w="${dims%,*}"; h="${dims#*,}"
  if [ -z "${w:-}" ] || [ -z "${h:-}" ]; then
    echo "SKIP  $name (cannot read dimensions)"
    continue
  fi

  # Decide crop: keep the larger dimension, trim the other until ratio matches.
  ratio_h="$(awk "BEGIN{printf \"%.4f\", $w/$h}")"
  if [ "$w" -ge "$h" ]; then
    target="16:9 (landscape)"; target_ratio="1.777777777777"
  else
    target="9:16 (portrait)"; target_ratio="0.5625"
  fi

  if awk "BEGIN{exit !($ratio_h > $target_ratio)}"; then
    # Too wide: crop width.
    cw="$(awk "BEGIN{print int($h * $target_ratio / 2) * 2}")"
    ch="$h"
    cx="$(awk "BEGIN{print int(($w - $cw) / 2)}")"
    cy=0
  else
    # Too tall: crop height.
    cw="$w"
    ch="$(awk "BEGIN{print int($w / $target_ratio / 2) * 2}")"
    cx=0
    cy="$(awk "BEGIN{print int(($h - $ch) / 2)}")"
  fi

  echo "==> $name (${w}x${h}) -> crop to ${cw}x${ch} $target"

  tmp_png="${OUT_DIR}/.${stem}.tmp.png"
  "$FFMPEG" -y -v error -i "$img" \
    -vf "crop=${cw}:${ch}:${cx}:${cy}" \
    -frames:v 1 "$tmp_png"

  size="$(stat -f%z "$tmp_png")"
  if [ "$size" -le "$MAX_BYTES" ]; then
    mv "$tmp_png" "$out_base.png"
    echo "     OK  $out_base.png (PNG, $((size / 1024)) KB)"
  else
    q=3
    out_jpg=""
    while [ "$q" -le 31 ]; do
      candidate="${OUT_DIR}/.${stem}.q${q}.jpg"
      "$FFMPEG" -y -v error -i "$tmp_png" -q:v "$q" "$candidate"
      size="$(stat -f%z "$candidate")"
      if [ "$size" -le "$MAX_BYTES" ]; then out_jpg="$candidate"; break; fi
      rm -f "$candidate"
      q=$((q + 2))
    done
    rm -f "$tmp_png"

    if [ -n "$out_jpg" ]; then
      mv "$out_jpg" "$out_base.jpg"
      echo "     OK  $out_base.jpg (JPEG q=$q, $((size / 1024)) KB)"
    else
      echo "FAIL  $name (still > 3 MB even at lowest JPEG quality)" >&2
      fail=$((fail + 1))
      continue
    fi
  fi

  pass=$((pass + 1))
done

echo "----------------------------------------"
echo "Done: $pass converted, $fail failed -> $OUT_DIR"
[ "$fail" -eq 0 ]