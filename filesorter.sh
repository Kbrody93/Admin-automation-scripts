display_file_info_last_accessed() {
  file=$1
  echo "File: $file || Last accessed: $(stat -f "%Sa" -t "%Y-%m-%d %H:%M:%S" "$file") || Creation date: $(stat -f "%SB" -t "%Y-%m-%d %H:%M:%S" "$file") || Size: $(du -sh "$file" | awk '{print $1}')"
}

display_file_info_size() {
  file=$1
  echo "File: $file || Size: $(du -sh "$file" | awk '{print $1}') || Creation date: $(stat -f "%SB" -t "%Y-%m-%d %H:%M:%S" "$file") || Last accessed: $(stat -f "%Sa" -t "%Y-%m-%d %H:%M:%S" "$file")"
}

echo "Files sorted by last accessed (least recent to most recent):"
for file in *; do
  display_file_info_last_accessed "$file"
done | sort -k4,4 -k5,5 

# Separator
echo -e "\n-----------------------------------------\n"

echo "Files sorted by size (largest to smallest):"
for file in *; do
  display_file_info_size "$file"
done | sort -h -k2,2 
