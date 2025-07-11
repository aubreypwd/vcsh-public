for img in "$@"; do
  /opt/homebrew/bin/cwebp -q 80 "$img" -o "$img.webp"
done