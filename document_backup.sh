#!/bin/bash

# Document Backup Script
echo "💾 Starting Document Backup..."
echo "=================================="

# Configuration
BACKUP_DIR="$HOME/Backups"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
BACKUP_NAME="documents_backup_$TIMESTAMP"
FULL_BACKUP_PATH="$BACKUP_DIR/$BACKUP_NAME"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

echo "📁 Backup location: $FULL_BACKUP_PATH"
echo ""

# Function to backup a directory
backup_directory() {
    local source_dir="$1"
    local backup_subdir="$2"
    
    if [ -d "$source_dir" ]; then
        echo "📂 Backing up $source_dir..."
        mkdir -p "$FULL_BACKUP_PATH/$backup_subdir"
        rsync -av --exclude='.DS_Store' --exclude='*.tmp' "$source_dir/" "$FULL_BACKUP_PATH/$backup_subdir/" >/dev/null 2>&1
        local file_count=$(find "$source_dir" -type f | wc -l | xargs)
        local size=$(du -sh "$source_dir" 2>/dev/null | cut -f1)
        echo "   ✅ $file_count files ($size) backed up"
    else
        echo "   ⚠️  Directory $source_dir not found, skipping"
    fi
}

# Backup important directories
backup_directory "$HOME/Documents" "Documents"
backup_directory "$HOME/Desktop" "Desktop"
backup_directory "$HOME/Scripts" "Scripts"

# Backup specific application data
echo ""
echo "⚙️  Backing up application preferences..."

# Raycast settings
if [ -d "$HOME/Library/Application Support/com.raycast.macos" ]; then
    backup_directory "$HOME/Library/Application Support/com.raycast.macos" "AppData/Raycast"
fi

# SSH keys
if [ -d "$HOME/.ssh" ]; then
    echo "🔑 Backing up SSH keys..."
    mkdir -p "$FULL_BACKUP_PATH/Config/ssh"
    cp "$HOME/.ssh/config" "$FULL_BACKUP_PATH/Config/ssh/" 2>/dev/null
    cp "$HOME/.ssh/*.pub" "$FULL_BACKUP_PATH/Config/ssh/" 2>/dev/null
    echo "   ✅ SSH configuration backed up"
fi

# Git configuration
if [ -f "$HOME/.gitconfig" ]; then
    echo "🌿 Backing up Git configuration..."
    mkdir -p "$FULL_BACKUP_PATH/Config"
    cp "$HOME/.gitconfig" "$FULL_BACKUP_PATH/Config/" 2>/dev/null
    echo "   ✅ Git config backed up"
fi

# Shell configurations
echo "🐚 Backing up shell configurations..."
mkdir -p "$FULL_BACKUP_PATH/Config/shell"
for config_file in .zshrc .bashrc .bash_profile .profile .vimrc .tmux.conf; do
    if [ -f "$HOME/$config_file" ]; then
        cp "$HOME/$config_file" "$FULL_BACKUP_PATH/Config/shell/" 2>/dev/null
    fi
done
echo "   ✅ Shell configs backed up"

# Create backup archive
echo ""
echo "📦 Creating compressed archive..."
cd "$BACKUP_DIR"
tar -czf "${BACKUP_NAME}.tar.gz" "$BACKUP_NAME" >/dev/null 2>&1
if [ $? -eq 0 ]; then
    # Remove uncompressed directory after successful compression
    rm -rf "$BACKUP_NAME"
    
    # Get archive size
    archive_size=$(du -sh "${BACKUP_NAME}.tar.gz" | cut -f1)
    echo "   ✅ Archive created: ${BACKUP_NAME}.tar.gz ($archive_size)"
else
    echo "   ⚠️  Archive creation failed, keeping uncompressed backup"
fi

# Cleanup old backups (keep last 5)
echo ""
echo "🧹 Cleaning up old backups (keeping latest 5)..."
ls -1t "$BACKUP_DIR"/documents_backup_*.tar.gz 2>/dev/null | tail -n +6 | while read old_backup; do
    rm -f "$old_backup"
    echo "   🗑️  Removed: $(basename "$old_backup")"
done

# Summary
echo ""
echo "=================================="
echo "✅ Backup completed successfully!"
echo "📊 Backup summary:"
echo "   📁 Location: $BACKUP_DIR"
echo "   📦 Latest: ${BACKUP_NAME}.tar.gz"
echo "   📈 Total backups: $(ls -1 "$BACKUP_DIR"/documents_backup_*.tar.gz 2>/dev/null | wc -l | xargs)"
echo "   💾 Total backup size: $(du -sh "$BACKUP_DIR" | cut -f1)"
echo "🕐 Completed at: $(date)"