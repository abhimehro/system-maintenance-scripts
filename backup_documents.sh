#!/bin/bash

# Important Documents Backup Script
echo "💾 Starting Weekly Document Backup..."
echo "========================================"

# Configuration
BACKUP_DIR="$HOME/Backups/WeeklyBackup"
DATE=$(date +%Y-%m-%d)
BACKUP_PATH="$BACKUP_DIR/$DATE"

# Create backup directory
mkdir -p "$BACKUP_PATH"

# Function to backup directory with progress
backup_directory() {
    local source="$1"
    local dest_name="$2"
    local description="$3"
    
    if [ -d "$source" ]; then
        echo "📁 Backing up $description..."
        local size_before=$(du -sh "$source" 2>/dev/null | cut -f1)
        rsync -av --progress "$source/" "$BACKUP_PATH/$dest_name/" 2>/dev/null
        echo "   ✅ $description backed up ($size_before)"
    else
        echo "   ⚠️  $description not found, skipping..."
    fi
}

# Function to backup specific file types
backup_file_types() {
    local source_dir="$1"
    local pattern="$2"
    local dest_name="$3"
    local description="$4"
    
    if [ -d "$source_dir" ]; then
        echo "📄 Backing up $description..."
        mkdir -p "$BACKUP_PATH/$dest_name"
        find "$source_dir" -name "$pattern" -type f -exec cp {} "$BACKUP_PATH/$dest_name/" \; 2>/dev/null
        local count=$(find "$BACKUP_PATH/$dest_name" -type f | wc -l)
        echo "   ✅ $count $description files backed up"
    fi
}

echo "📍 Backup location: $BACKUP_PATH"
echo ""

# 1. Backup Documents folder
backup_directory "$HOME/Documents" "Documents" "Documents folder"

# 2. Backup Desktop (important files only)
backup_directory "$HOME/Desktop" "Desktop" "Desktop files"

# 3. Backup specific file types from various locations
backup_file_types "$HOME" "*.pdf" "PDFs" "PDF"
backup_file_types "$HOME" "*.docx" "Word_Docs" "Word document"
backup_file_types "$HOME" "*.xlsx" "Excel_Files" "Excel"
backup_file_types "$HOME" "*.pptx" "PowerPoint_Files" "PowerPoint"

# 4. Backup SSH keys and config
if [ -d "$HOME/.ssh" ]; then
    echo "🔑 Backing up SSH configuration..."
    mkdir -p "$BACKUP_PATH/SSH_Config"
    cp "$HOME/.ssh/config" "$BACKUP_PATH/SSH_Config/" 2>/dev/null
    cp "$HOME/.ssh/*.pub" "$BACKUP_PATH/SSH_Config/" 2>/dev/null
    echo "   ✅ SSH configuration backed up"
fi

# 5. Backup important dotfiles
echo "⚙️  Backing up configuration files..."
mkdir -p "$BACKUP_PATH/Config_Files"
config_files=(
    ".zshrc"
    ".bashrc"
    ".gitconfig"
    ".vimrc"
    ".tmux.conf"
)

for file in "${config_files[@]}"; do
    if [ -f "$HOME/$file" ]; then
        cp "$HOME/$file" "$BACKUP_PATH/Config_Files/"
        echo "   ✅ $file backed up"
    fi
done

# 6. Backup browser bookmarks
echo "🌐 Backing up browser bookmarks..."
mkdir -p "$BACKUP_PATH/Browser_Data"

# Safari bookmarks
if [ -f "$HOME/Library/Safari/Bookmarks.plist" ]; then
    cp "$HOME/Library/Safari/Bookmarks.plist" "$BACKUP_PATH/Browser_Data/Safari_Bookmarks.plist"
    echo "   ✅ Safari bookmarks backed up"
fi

# Chrome bookmarks
if [ -f "$HOME/Library/Application Support/Google/Chrome/Default/Bookmarks" ]; then
    cp "$HOME/Library/Application Support/Google/Chrome/Default/Bookmarks" "$BACKUP_PATH/Browser_Data/Chrome_Bookmarks.json"
    echo "   ✅ Chrome bookmarks backed up"
fi

# 7. Create backup summary
echo ""
echo "📋 Creating backup summary..."
cat > "$BACKUP_PATH/BACKUP_SUMMARY.txt" << EOF
Backup Summary - $DATE
======================================

Backup Location: $BACKUP_PATH
Backup Date: $(date)
System: $(uname -a)

Directories Backed Up:
- Documents folder
- Desktop files
- SSH configuration
- Configuration files (.zshrc, .gitconfig, etc.)
- Browser bookmarks

File Types Backed Up:
- PDF files
- Word documents (.docx)
- Excel files (.xlsx)
- PowerPoint files (.pptx)

Total Backup Size: $(du -sh "$BACKUP_PATH" | cut -f1)

EOF

# 8. Cleanup old backups (keep last 4 weeks)
echo "🧹 Cleaning up old backups (keeping last 4 weeks)..."
find "$BACKUP_DIR" -type d -name "20*" -mtime +28 -exec rm -rf {} \; 2>/dev/null
echo "   ✅ Old backups cleaned up"

# 9. Show final summary
echo ""
echo "========================================"
echo "✅ Backup complete!"
echo "📊 Backup Statistics:"
echo "   Location: $BACKUP_PATH"
echo "   Total size: $(du -sh "$BACKUP_PATH" | cut -f1)"
echo "   Files backed up: $(find "$BACKUP_PATH" -type f | wc -l)"
echo "   Available backups: $(ls -1 "$BACKUP_DIR" | wc -l) weeks"
echo "🕐 Completed at: $(date)"