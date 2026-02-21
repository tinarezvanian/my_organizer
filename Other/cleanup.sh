for file in "/Users/tina/Library/Mobile Documents/com~apple~CloudDocs/Tina_backup_may_9"/*; do
    # Run rsync to copy the file
    rsync -av "$file" "/Users/tina/work_backup/"

    # If rsync is successful, delete the file
    if [ $? -eq 0 ]; then
        rm -rf "$file"
    fi
done
