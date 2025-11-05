#!/bin/zsh

# Copy Lobby repo template files to target directory
# Usage: copy_lobby_files /path/to/target/repo

copy_lobby_files() {
    # Check if target directory was provided
    if [[ -z "$1" ]]; then
        echo "Error: No target directory specified"
        echo "Usage: copy_lobby_files /path/to/target/repo"
        return 1
    fi

    local target_dir="$1"
    local github_source="$HOME/Documents/Obsidian/Alaska/Development/Lobby repo files/github"
    local md_source="$HOME/Documents/Obsidian/Alaska/Development/Lobby repo files"

    # Verify target directory exists
    if [[ ! -d "$target_dir" ]]; then
        echo "Error: Target directory does not exist: $target_dir"
        return 1
    fi

    # Verify source directories exist
    if [[ ! -d "$github_source" ]]; then
        echo "Error: GitHub source directory does not exist: $github_source"
        return 1
    fi

    if [[ ! -d "$md_source" ]]; then
        echo "Error: Markdown source directory does not exist: $md_source"
        return 1
    fi

    # Verify .github directory exists in target
    local target_github="$target_dir/.github"
    if [[ ! -d "$target_github" ]]; then
        echo "Error: .github directory does not exist in target: $target_github"
        return 1
    fi

    # Copy github directory contents
    echo "Copying .github files..."
    cp -r "$github_source/"* "$target_github/" 2>/dev/null
    if [[ $? -eq 0 ]]; then
        echo "✓ Copied .github directory contents"
    else
        echo "⚠ No files found in github source or copy failed"
    fi

    # Copy *-src.md files
    echo "Copying *-src.md files..."
    local copied_count=0
    for file in "$md_source"/*-src.md(N); do
        if [[ -f "$file" ]]; then
            cp "$file" "$target_dir/"
            echo "✓ Copied: $(basename "$file")"
            ((copied_count++))
        fi
    done

    if [[ $copied_count -eq 0 ]]; then
        echo "⚠ No *-src.md files found"
    else
        echo "✓ Copied $copied_count markdown file(s)"
    fi

    echo "Done!"
}
