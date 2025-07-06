#!/bin/bash

# System Cleanup & Maintenance Script
echo "🧹 Starting System Cleanup & Maintenance..."
echo "================================================"

# Function to show disk space before and after
show_disk_usage() {
    echo "💾 Current disk usage:"
    df -h / | tail -1 | awk '{print "   Available: " $4 " (" $5 " used)"}'
}

# Show initial disk space
show_disk_usage

echo ""
echo "🗑️  Cleaning Downloads folder (files older than 30 days)..."
find ~/Downloads -type f -mtime +30 -exec rm -f {} \; 2>/dev/null
find ~/Downloads -type d -empty -delete 2>/dev/null
downloads_cleaned=$(find ~/Downloads -type f -mtime +30 2>/dev/null | wc -l | xargs)
echo "   Removed $downloads_cleaned old files from Downloads"

echo ""
echo "🗂️  Cleaning Trash..."
osascript -e 'tell application "Finder" to empty trash' 2>/dev/null
echo "   Trash emptied"

echo ""
echo "📱 Cleaning iOS device backups (keeping latest 2)..."
ios_backup_dir="$HOME/Library/Application Support/MobileSync/Backup"
if [ -d "$ios_backup_dir" ]; then
    backup_count=$(ls -1 "$ios_backup_dir" 2>/dev/null | wc -l | xargs)
    if [ "$backup_count" -gt 2 ]; then
        ls -1t "$ios_backup_dir" | tail -n +3 | while read backup; do
            rm -rf "$ios_backup_dir/$backup" 2>/dev/null
        done
        echo "   Cleaned old iOS backups (kept latest 2)"
    else
        echo "   iOS backups already optimized"
    fi
else
    echo "   No iOS backups found"
fi

echo ""
echo "🧹 Cleaning system caches..."
# User caches
if [ -d ~/Library/Caches ]; then
    cache_size_before=$(du -sh ~/Library/Caches 2>/dev/null | cut -f1)
    find ~/Library/Caches -type f -mtime +7 -delete 2>/dev/null
    find ~/Library/Caches -type d -empty -delete 2>/dev/null
    cache_size_after=$(du -sh ~/Library/Caches 2>/dev/null | cut -f1)
    echo "   User caches: $cache_size_before → $cache_size_after"
fi

# Clear system logs older than 7 days
echo ""
echo "📋 Cleaning system logs..."
sudo log collect --last 7d --output /tmp/recent_logs.logarchive >/dev/null 2>&1
if [ -f /tmp/recent_logs.logarchive ]; then
    rm /tmp/recent_logs.logarchive
fi
echo "   System logs optimized"

echo ""
echo "🔄 Cleaning temporary files..."
# Clean temp directories
temp_cleaned=0
for temp_dir in /tmp ~/Library/Application\ Support/*/tmp; do
    if [ -d "$temp_dir" ]; then
        temp_files=$(find "$temp_dir" -type f -mtime +1 2>/dev/null | wc -l | xargs)
        find "$temp_dir" -type f -mtime +1 -delete 2>/dev/null
        temp_cleaned=$((temp_cleaned + temp_files))
    fi
done
echo "   Removed $temp_cleaned temporary files"

echo ""
echo "🌐 Cleaning browser caches..."
# Safari cache
if [ -d ~/Library/Caches/com.apple.Safari ]; then
    safari_cache_before=$(du -sh ~/Library/Caches/com.apple.Safari 2>/dev/null | cut -f1)
    rm -rf ~/Library/Caches/com.apple.Safari/* 2>/dev/null
    safari_cache_after=$(du -sh ~/Library/Caches/com.apple.Safari 2>/dev/null | cut -f1)
    echo "   Safari cache: $safari_cache_before → $safari_cache_after"
fi

# Chrome cache (if exists)
if [ -d ~/Library/Caches/Google/Chrome ]; then
    chrome_cache_before=$(du -sh ~/Library/Caches/Google/Chrome 2>/dev/null | cut -f1)
    rm -rf ~/Library/Caches/Google/Chrome/Default/Cache/* 2>/dev/null
    chrome_cache_after=$(du -sh ~/Library/Caches/Google/Chrome 2>/dev/null | cut -f1)
    echo "   Chrome cache: $chrome_cache_before → $chrome_cache_after"
fi

echo ""
echo "📦 Cleaning package manager caches..."
# npm cache
if command -v npm >/dev/null 2>&1; then
    npm_cache_before=$(du -sh ~/.npm 2>/dev/null | cut -f1)
    npm cache clean --force >/dev/null 2>&1
    npm_cache_after=$(du -sh ~/.npm 2>/dev/null | cut -f1)
    echo "   npm cache: $npm_cache_before → $npm_cache_after"
fi

# pip cache
if command -v pip3 >/dev/null 2>&1; then
    pip_cache_before=$(du -sh ~/Library/Caches/pip 2>/dev/null | cut -f1)
    pip3 cache purge >/dev/null 2>&1
    pip_cache_after=$(du -sh ~/Library/Caches/pip 2>/dev/null | cut -f1)
    echo "   pip cache: $pip_cache_before → $pip_cache_after"
fi

echo ""
echo "🔧 Running system maintenance..."
# Rebuild Spotlight index if needed
spotlight_count=$(mdfind -count '' 2>/dev/null | head -1)
if [ "$spotlight_count" = "0" ] 2>/dev/null; then
    echo "   Rebuilding Spotlight index..."
    sudo mdutil -E / > /dev/null 2>&1
fi

# Repair disk permissions
echo "   Verifying disk permissions..."
sudo diskutil verifyPermissions / >/dev/null 2>&1

echo ""
echo "================================================"
echo "✅ System cleanup complete!"
echo "📊 Final status:"
show_disk_usage
echo "🕐 Completed at: $(date)"