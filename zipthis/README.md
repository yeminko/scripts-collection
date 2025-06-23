# ZipThis - Smart Folder Archiver

A bash script that creates zip archives while respecting `.gitignore` rules and automatically excluding Git repositories.

## Features

- 🚀 **Simple Usage**: One command to zip any folder
- 📝 **Gitignore Aware**: Automatically excludes files and folders listed in `.gitignore`
- 🔒 **Git Safe**: Always excludes `.git` directories to keep archives clean
- 🎯 **Smart Pattern Matching**: Handles various `.gitignore` pattern types
- 📊 **Informative Output**: Shows exclusions, archive size, and file count
- ✅ **Error Handling**: Validates inputs and provides helpful error messages

## Installation

1. Clone or download the script:

   ```bash
   curl -O https://raw.githubusercontent.com/scripts-collection/zipthis/zipthis.sh
   ```

2. Make it executable:

   ```bash
   chmod +x zipthis.sh
   ```

3. (Optional) Add to your PATH for global access:

   ```bash
   sudo cp zipthis.sh /usr/local/bin/zipthis
   ```

## Usage

### Basic Usage

```bash
./zipthis.sh /path/to/folder
```

### Examples

```bash
# Zip a project in your current directory
./zipthis.sh ./my-project

# Zip a project with absolute path
./zipthis.sh /Users/username/Documents/my-app

# Zip from any location
./zipthis.sh ~/Desktop/some-folder
```

## How It Works

1. **Validation**: Checks if the specified folder exists
2. **Gitignore Processing**: 
   - Looks for `.gitignore` in the target folder
   - Parses each line and converts patterns to zip exclusions
   - Handles comments, empty lines, and various pattern types
3. **Git Directory Exclusion**: Always excludes `.git` folders if present
4. **Archive Creation**: Creates `{folder-name}.zip` in the current working directory
5. **Summary**: Displays archive statistics and exclusion summary

## Supported Gitignore Patterns

The script handles various `.gitignore` pattern types:

| Pattern Type | Example | Description |
|-------------|---------|-------------|
| **Files** | `*.log` | Excludes all `.log` files |
| **Directories** | `node_modules/` | Excludes entire directories |
| **Root Paths** | `/config.json` | Excludes from project root only |
| **Nested Paths** | `src/temp/*` | Excludes specific nested locations |
| **Comments** | `# This is ignored` | Skipped (not processed) |

## Output Example

```bash
Creating zip archive: my-project.zip
Source folder: /Users/username/my-project
Found .gitignore file, processing exclusions...
  Excluding: *.log
  Excluding: node_modules/
  Excluding: .env
  Excluding: dist/
Excluding .git directory...
Executing zip command...
  adding: my-project/ (stored 0%)
  adding: my-project/src/ (stored 0%)
  adding: my-project/package.json (deflated 45%)
  ...
Successfully created: my-project.zip
Archive size: 2.1M
Files in archive: 127
```

## Requirements

- **Unix-like system** (macOS, Linux, WSL)
- **Bash** (version 3.0+)
- **zip** command (usually pre-installed)
- **realpath** command (usually pre-installed on modern systems)

## Error Handling

The script provides clear error messages for common issues:

- **Missing argument**: Shows usage instructions
- **Non-existent folder**: Reports the invalid path
- **Permission issues**: Standard system error messages
- **Zip creation failure**: Reports archive creation problems

## Limitations

- Only processes `.gitignore` files in the root of the target folder
- Does not follow `.gitignore` files in subdirectories
- Complex gitignore patterns (like negation with `!`) have limited support
- Requires the `zip` command to be available

## Contributing

Feel free to submit issues, fork the repository, and create pull requests for any improvements.

## License

This script is released under the MIT License. See LICENSE file for details.

## Changelog

### v1.0.0

- Initial release
- Basic .gitignore processing
- .git directory exclusion
- Archive statistics display

---

**💡 Tip**: Use this script to create clean archives of your projects without accidentally including build artifacts, dependencies, or sensitive files listed in your `.gitignore`!
