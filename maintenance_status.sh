#!/bin/bash

# Master Maintenance Control Script
echo "🤖 System Maintenance Control Center"
echo "===================================="
echo ""

# Function to show script status
show_script_status() {
    local script_name="$1"
    local description="$2"
    local log_file="$3"
    
    echo "📋 $description"
    echo "   Script: ~/Scripts/$script_name"
    echo "   Status: $([ -x ~/Scripts/$script_name ] && echo "✅ Ready" || echo "❌ Not found")"
    
    if [ -f "$log_file" ]; then
        local last_run=$(stat -f "%Sm" -t "%Y-%m-%d %H:%M" "$log_file" 2>/dev/null)
        echo "   Last run: $last_run"
        local log_size=$(du -sh "$log_file" 2>/dev/null | cut -f1)
        echo "   Log size: $log_size"
    else
        echo "   Last run: Never"
    fi
    echo ""
}

# Show all maintenance scripts
echo "📊 Maintenance Scripts Status:"
echo ""

show_script_status "brew_maintenance.sh" "🍺 Homebrew Maintenance" "~/Scripts/brew_maintenance.log"
show_script_status "system_cleanup.sh" "🧹 System Cleanup" "~/Scripts/system_cleanup.log"
show_script_status "document_backup.sh" "💾 Document Backup" "~/Scripts/document_backup.log"
show_script_status "package_updates.sh" "📦 Package Updates" "~/Scripts/package_updates.log"

# Show schedule
echo "⏰ Automated Schedule:"
echo "   🍺 Homebrew: Sundays at 10:00 AM"
echo "   🧹 Cleanup: Wednesdays at 9:00 AM"
echo "   💾 Backup: Fridays at 6:00 PM"
echo "   📦 Updates: Tuesdays at 11:00 AM"
echo ""

# Show disk usage
echo "💾 Current System Status:"
df -h / | tail -1 | awk '{print "   Disk usage: " $5 " used, " $4 " available"}'

# Show backup status
if [ -d ~/Backups ]; then
    backup_count=$(ls -1 ~/Backups/documents_backup_*.tar.gz 2>/dev/null | wc -l | xargs)
    backup_size=$(du -sh ~/Backups 2>/dev/null | cut -f1)
    echo "   Backups: $backup_count archives ($backup_size total)"
else
    echo "   Backups: No backup directory found"
fi

echo ""
echo "🎯 Quick Actions:"
echo "   Run all maintenance: ~/Scripts/run_all_maintenance.sh"
echo "   View logs: ls -la ~/Scripts/*.log"
echo "   Edit schedule: crontab -e"
echo ""
echo "✅ System maintenance is fully automated!"