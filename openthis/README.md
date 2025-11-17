# OpenThis - VS Code Project Launcher

A bash script that quickly opens VS Code projects by loading paths from a configuration file, eliminating the need to navigate through "Open Recent" menus.

## Features

- 🚀 **Quick Access**: One command to open any project
- ⚙️ **Simple Config**: Uses `.openthis` file for project paths
- 📂 **Multiple Sources**: Supports additional config via `CUSTOM_CONFIG_PATH`
- 📊 **List Projects**: Shows all available projects
- ✅ **Path Validation**: Validates directories before opening

## Installation

1. Download and make executable:

   ```bash
   curl -O https://raw.githubusercontent.com/yeminko/scripts-collection/main/openthis/openthis.sh
   chmod +x openthis.sh
   ```

2. Create `.openthis` file:

   ```bash
   # Example .openthis file
   frontend=/path/to/your/frontend/project
   backend=/path/to/your/backend/project

   # Optional: Load additional projects
   CUSTOM_CONFIG_PATH=~/Desktop/more-projects.txt
   ```

3. (Optional) Add to your PATH for global access:

   ```bash
   sudo cp openthis.sh /usr/local/bin/openthis
   ```

   **Note**: For global installation, create `$HOME/.openthis` instead of a local `.openthis` file.

## Usage

```bash
./openthis.sh frontend    # Open frontend project
./openthis.sh backend     # Open backend project
./openthis.sh list        # List all projects
./openthis.sh             # Same as list
```

## Configuration

Create `.openthis` file in the script directory:

```bash
# Main projects
frontend=/Users/username/my-app/frontend
backend=/Users/username/my-app/backend
mobile=~/projects/mobile-app

# Load additional projects (optional)
CUSTOM_CONFIG_PATH=~/Desktop/work-projects.txt
```

## How It Works

1. **Loads** `.openthis` file from script directory
2. **Optionally loads** additional config from `CUSTOM_CONFIG_PATH`
3. **Validates** project exists and directory is accessible
4. **Opens** project in VS Code

## Example Output

```bash
$ ./openthis.sh frontend
Opening frontend: /Users/username/my-app/frontend

$ ./openthis.sh list
Available projects:
backend
frontend
mobile
```

## Requirements

- **Bash** shell
- **VS Code** with `code` command in PATH

## Why OpenThis?

- **Fast**: No clicking through menus
- **Organized**: Keep projects in simple config files
- **Scalable**: Handle many projects easily
- **Shareable**: Team members can use same config

**💡 Tip**: Create aliases like `alias fe='./openthis.sh frontend'` for even faster access!
