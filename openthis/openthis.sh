#!/bin/bash

# Load .openthis configuration
load_config() {
    local config_file="$(dirname "$0")/.openthis"
    
    # If local config doesn't exist, try home directory
    if [[ ! -f "$config_file" ]]; then
        config_file="$HOME/.openthis"
    fi
    
    if [[ ! -f "$config_file" ]]; then
        echo "Error: .openthis file not found"
        echo "Create .openthis file at:"
        echo "  $(dirname "$0")/.openthis (local)"
        echo "  $HOME/.openthis (global)"
        exit 1
    fi
    
    source "$config_file"
    
    # Load additional config if CUSTOM_CONFIG_PATH is set
    if [[ -n "$CUSTOM_CONFIG_PATH" ]]; then
        local custom_path="${CUSTOM_CONFIG_PATH/#\~/$HOME}"
        if [[ -f "$custom_path" ]]; then
            source "$custom_path"
        fi
    fi
}

# Show available projects
show_projects() {
    echo "Available projects:"
    {
        grep -E '^[a-zA-Z_][a-zA-Z0-9_]*=' "$(dirname "$0")/.openthis" 2>/dev/null | grep -v '^CUSTOM_CONFIG_PATH=' | cut -d'=' -f1
        if [[ -n "$CUSTOM_CONFIG_PATH" ]]; then
            local custom_path="${CUSTOM_CONFIG_PATH/#\~/$HOME}"
            [[ -f "$custom_path" ]] && grep -E '^[a-zA-Z_][a-zA-Z0-9_]*=' "$custom_path" 2>/dev/null | cut -d'=' -f1
        fi
    } | sort | uniq
}

# Main function
main() {
    local project_name="$1"
    
    load_config
    
    if [[ -z "$project_name" ]] || [[ "$project_name" == "list" ]]; then
        show_projects
        exit 0
    fi
    
    # Get project path
    local project_path="${!project_name}"
    
    if [[ -z "$project_path" ]]; then
        echo "Error: Project '$project_name' not found"
        show_projects
        exit 1
    fi
    
    # Expand tilde and validate directory
    project_path="${project_path/#\~/$HOME}"
    
    if [[ ! -d "$project_path" ]]; then
        echo "Error: Directory '$project_path' does not exist"
        exit 1
    fi
    
    echo "Opening $project_name: $project_path"
    code "$project_path"
}

main "$1"