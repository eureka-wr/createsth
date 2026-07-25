#!/bin/zsh
set -euo pipefail

PROJECT_ROOT="${1:-$(pwd)}"
SOURCE_DIR="$PROJECT_ROOT/deliverables/wechat-video/source"
BUILD_DIR="$PROJECT_ROOT/deliverables/wechat-video/.build"

mkdir -p "$BUILD_DIR"

python3 "$SOURCE_DIR/make_music.py"
say \
  -v 'Shelley (Chinese (China mainland))' \
  -r 175 \
  -f "$SOURCE_DIR/narration.txt" \
  -o "$SOURCE_DIR/narration.aiff"

swiftc \
  -parse-as-library \
  -framework AppKit \
  -framework AVFoundation \
  -framework CoreVideo \
  "$SOURCE_DIR/render_video.swift" \
  -o "$BUILD_DIR/render_video"

swiftc \
  -parse-as-library \
  -framework AVFoundation \
  "$SOURCE_DIR/mux_audio.swift" \
  -o "$BUILD_DIR/mux_audio"

"$BUILD_DIR/render_video" "$PROJECT_ROOT"
"$BUILD_DIR/mux_audio" "$PROJECT_ROOT"

echo "$PROJECT_ROOT/deliverables/wechat-video/output/jessica-wechat-video.mp4"
