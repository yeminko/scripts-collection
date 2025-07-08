#!/bin/bash

# Check if path argument is provided
if [ $# -eq 0 ]; then
    echo "Usage: $0 <path_to_folder>"
    echo "Example: $0 /path/to/folder"
    exit 1
fi

# Get the absolute path of the folder to zip
FOLDER_PATH="$(realpath "$1")"
FOLDER_NAME="$(basename "$FOLDER_PATH")"

# Check if the folder exists
if [ ! -d "$FOLDER_PATH" ]; then
    echo "Error: Directory '$FOLDER_PATH' does not exist."
    exit 1
fi

# Output zip file name
ZIP_FILE="${FOLDER_NAME}.zip"

# Remove existing zip file if it exists
if [ -f "$ZIP_FILE" ]; then
    echo "Removing existing $ZIP_FILE..."
    rm "$ZIP_FILE"
fi

# Change to the parent directory of the folder to zip
PARENT_DIR="$(dirname "$FOLDER_PATH")"
cd "$PARENT_DIR" || exit 1

echo "Creating zip archive: $ZIP_FILE"
echo "Source folder: $FOLDER_PATH"

# Start building the zip command
ZIP_CMD="zip -r '$ZIP_FILE' '$FOLDER_NAME'"

# Always exclude .git directory if it exists
if [ -d "$FOLDER_PATH/.git" ]; then
    echo "Excluding .git directory..."
    ZIP_CMD="$ZIP_CMD -x '$FOLDER_NAME/.git/*'"
fi

# Check if .gitignore exists
GITIGNORE_PATH="$FOLDER_PATH/.gitignore"
if [ -f "$GITIGNORE_PATH" ]; then
    echo "Found .gitignore file, processing exclusions..."
    
    # Read .gitignore and process each line
    while IFS= read -r line || [ -n "$line" ]; do
        # Skip empty lines and comments
        if [[ -z "$line" || "$line" =~ ^[[:space:]]*# ]]; then
            continue
        fi
        
        # Remove leading/trailing whitespace
        pattern=$(echo "$line" | sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
        
        # Skip if pattern is empty after trimming
        if [[ -z "$pattern" ]]; then
            continue
        fi
        
        # Handle different gitignore patterns
        if [[ "$pattern" == /* ]]; then
            # Pattern starts with / - match from root (remove leading /)
            clean_pattern="${pattern#/}"
            exclude_pattern="$FOLDER_NAME/$clean_pattern"
            # Add exclusion for the pattern and all subdirectories
            ZIP_CMD="$ZIP_CMD -x '$exclude_pattern' '$exclude_pattern/*'"
        elif [[ "$pattern" == */ ]]; then
            # Pattern ends with / - it's a directory
            exclude_pattern="$FOLDER_NAME/$pattern*"
            ZIP_CMD="$ZIP_CMD -x '$exclude_pattern'"
        elif [[ "$pattern" == */* ]]; then
            # Pattern contains / - match relative path
            exclude_pattern="$FOLDER_NAME/$pattern"
            ZIP_CMD="$ZIP_CMD -x '$exclude_pattern' '$exclude_pattern/*'"
        else
            # Simple pattern - match anywhere (both in root and subdirectories)
            # Match in root directory
            ZIP_CMD="$ZIP_CMD -x '$FOLDER_NAME/$pattern' '$FOLDER_NAME/$pattern/*'"
            # Match in any subdirectory
            ZIP_CMD="$ZIP_CMD -x '$FOLDER_NAME/*/$pattern' '$FOLDER_NAME/*/$pattern/*'"
        fi
        
        echo "  Excluding: $pattern"
        
    done < "$GITIGNORE_PATH"
else
    echo "No .gitignore file found, no additional exclusions."
fi

# Execute the zip command
echo "Executing zip command..."
eval "$ZIP_CMD"

# Check if zip was successful
if [ $? -eq 0 ]; then
    # Get the full path of the created zip file
    ZIP_FULL_PATH="$PARENT_DIR/$ZIP_FILE"
    echo "Successfully created: $ZIP_FULL_PATH"
    
    # Show zip file size
    if command -v du >/dev/null 2>&1; then
        SIZE=$(du -h "$ZIP_FILE" | cut -f1)
        echo "Archive size: $SIZE"
    fi
    
    # Show number of files in archive
    if command -v unzip >/dev/null 2>&1; then
        FILE_COUNT=$(unzip -l "$ZIP_FILE" | tail -1 | awk '{print $2}')
        echo "Files in archive: $FILE_COUNT"
    fi
else
    echo "Error: Failed to create zip archive."
    exit 1
fi
