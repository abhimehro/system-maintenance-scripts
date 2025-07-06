#!/usr/bin/env bash -l

# Run All Maintenance Script
echo "🚀 Running Complete System Maintenance..."
echo "========================================"
echo ""

# Function to run script with timing
run_maintenance() {
    local script="$1"
    local description="$2"
    
    echo "🔄 Starting: $description"
    echo "----------------------------------------"
    
    start_time=$(date +%s)
    bash -l -c "~/Scripts/$script"
    end_time=$(date +%s)
    
    duration=$((end_time - start_time))
    echo ""
    echo "✅ Completed: $description (${duration}s)"
    echo "========================================"
    echo ""
}

# Run all maintenance scripts in order
run_maintenance "system_cleanup.sh" "🧹 System Cleanup"
run_maintenance "package_updates.sh" "📦 Package Updates"
run_maintenance "brew_maintenance.sh" "🍺 Homebrew Maintenance"
run_maintenance "document_backup.sh" "💾 Document Backup"

echo "🎉 All maintenance tasks completed!"
echo "📊 Check individual logs for details:"
echo "   ~/Scripts/system_cleanup.log"
echo "   ~/Scripts/package_updates.log"
echo "   ~/Scripts/brew_maintenance.log"
echo "   ~/Scripts/document_backup.log"
echo ""
echo "🕐 Full maintenance completed at: $(date)"