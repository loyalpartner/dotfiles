#!/bin/bash

# Rofi Incus Plugin
# Manages Incus containers and VMs through rofi interface
# Author: User
# Dependencies: incus, jq, foot
#
# Usage:
#   1. Add to rofi config: incus:~/dotfiles/bin/rofi-incus.sh
#   2. Run: rofi -show incus
#   3. Select instance to connect:
#      - Virtual Machine (🖥️): Opens VGA console with foot
#      - Container (📦): Opens bash shell with foot
#      - Stopped instances: Attempts to start them first
#
# Features:
#   - Shows current remote's instances
#   - Displays status and description
#   - Automatically handles VM console and container exec
#   - Uses foot terminal for connections

function check_dependencies() {
    local missing_deps=()

    if ! command -v incus &> /dev/null; then
        missing_deps+=("incus")
    fi

    if ! command -v jq &> /dev/null; then
        missing_deps+=("jq")
    fi

    if ! command -v foot &> /dev/null; then
        missing_deps+=("foot")
    fi

    if [ ${#missing_deps[@]} -ne 0 ]; then
        echo "Missing dependencies: ${missing_deps[*]}"
        echo "Please install: ${missing_deps[*]}"
        exit 1
    fi
}

function get_current_remote() {
    incus remote get-default 2>/dev/null || echo "local"
}

function get_remotes() {
    # Get current default remote
    local default_remote
    default_remote=$(incus remote get-default 2>/dev/null || echo "local")

    # Only return the default remote to avoid duplicates
    # since other remotes might point to the same daemon
    echo "$default_remote"
}

function get_all_instances() {
    local remote="$1"
    local remote_prefix=""

    # Test if remote is accessible
    if ! incus remote list --format json | jq -e "has(\"$remote\")" >/dev/null 2>&1; then
        return 1
    fi

    if [ "$remote" != "local" ]; then
        remote_prefix="${remote}:"
    fi

    # Get all instances from all projects using --all-projects
    incus list ${remote_prefix} --all-projects --format json 2>/dev/null | jq -r --arg remote "$remote" '
        .[] |
        select(.name != null) |
        {
            remote: $remote,
            project: .project,
            name: .name,
            status: .status,
            type: .type,
            description: (.config."image.description" // .description // "")
        } |
        @base64
    '
}

function format_instance_list() {
    local current_remote
    current_remote=$(get_current_remote)

    local instances
    instances=$(get_all_instances "$current_remote")

    if [ -z "$instances" ]; then
        echo "No instances available"
        return 0
    fi

    while IFS= read -r instance_data; do
        if [ -z "$instance_data" ]; then
            continue
        fi

        local decoded
        decoded=$(echo "$instance_data" | base64 -d)

        local name status type description project
        name=$(echo "$decoded" | jq -r '.name')
        status=$(echo "$decoded" | jq -r '.status')
        type=$(echo "$decoded" | jq -r '.type')
        description=$(echo "$decoded" | jq -r '.description')
        project=$(echo "$decoded" | jq -r '.project')

        # Choose icon based on type
        local icon
        if [ "$type" = "virtual-machine" ]; then
            icon="🖥️"
        else
            icon="📦"
        fi

        # Truncate description if too long
        if [ ${#description} -gt 40 ]; then
            description="${description:0:37}..."
        fi

        # Format: icon [project] name - status - description
        local display_text="${icon} [${project}] ${name} - ${status} - ${description}"
        local info_data="${current_remote}:${project}:${name}:${type}:${status}"

        printf "%s\0info\x1f%s\n" "$display_text" "$info_data"

    done <<< "$instances"
}

function execute_action() {
    local info_data="${ROFI_INFO:-$1}"

    if [ -z "$info_data" ]; then
        echo "No instance selected"
        exit 1
    fi

    # Parse info_data: remote:project:name:type:status
    IFS=':' read -r remote project name type status <<< "$info_data"

    if [ -z "$remote" ] || [ -z "$project" ] || [ -z "$name" ] || [ -z "$type" ] || [ -z "$status" ]; then
        echo "Invalid instance data: $info_data"
        exit 1
    fi

    # Build remote prefix
    local remote_prefix=""
    if [ "$remote" != "local" ]; then
        remote_prefix="${remote}:"
    fi

    local target="${remote_prefix}${name}"

    # Handle stopped instances
    if [ "$status" = "Stopped" ] || [ "$status" = "STOPPED" ]; then
        # Try to start the instance
        incus start "$target" --project "$project" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo "Starting $target..."
            sleep 3
            # Continue to connect after starting
        else
            echo "Failed to start $target. Try manually: incus start $target --project $project"
            exit 1
        fi
    fi

    # Execute appropriate command based on type
    if [ "$type" = "virtual-machine" ]; then
        # VM: open VGA console
        setsid incus console "$target" --project "$project" --type=vga >/dev/null 2>&1 &
    elif [ "$type" = "container" ]; then
        # Container: exec bash
        setsid foot incus exec "$target" --project "$project" -- bash >/dev/null 2>&1 &
    else
        echo "Unknown instance type: $type"
        exit 1
    fi
}

function main() {
    check_dependencies

    if [ "${ROFI_RETV:-0}" -eq "0" ]; then
        # Initial call - show instance list
        format_instance_list
    else
        # Item selected - execute action
        execute_action
    fi
}

main "$@"
