dir="$1"
new_file_path="$dir/newfile.txt"
if [ ! -e "$new_file_path" ]; then
  touch "$new_file_path"
  exit 0
fi

i=1
while true; do
  file_path="$dir/newfile-$i.txt"
  if [ ! -e "$file_path" ]; then
    touch "$file_path"
    break
  fi
  i=$((i + 1))
done
