# System Maintenance Scripts Suite

## Overview
A comprehensive collection of automated maintenance scripts for macOS systems, designed to keep your development environment clean, updated, and backed up. The suite includes individual maintenance scripts and a centralized weekly automation job.

## Quick Start
```bash
# Run all maintenance tasks manually
~/Scripts/run_all_maintenance.sh

# Check system status
~/Scripts/maintenance_status.sh

# Run individual maintenance scripts
~/Scripts/brew_maintenance.sh
~/Scripts/system_cleanup.sh
~/Scripts/document_backup.sh
~/Scripts/package_updates.sh
~/Scripts/dev_maintenance.sh
```

## Script Collection

### Core Maintenance Scripts
1. **`run_all_maintenance.sh`** - Master script that orchestrates all maintenance tasks
2. **`brew_maintenance.sh`** - Homebrew package management and cleanup
3. **`system_cleanup.sh`** - System cache cleanup and optimization
4. **`document_backup.sh`** - Document and configuration file backup
5. **`package_updates.sh`** - System and application package updates
6. **`dev_maintenance.sh`** - Development environment maintenance (npm, pip, gems, etc.)
7. **`maintenance_status.sh`** - System status dashboard and script health check

### Raycast Integration Scripts
- **`raycast-brew-maintenance.sh`** - Quick Homebrew maintenance via Raycast
- **`raycast-system-cleanup.sh`** - Quick system cleanup via Raycast
- **`raycast-document-backup.sh`** - Quick document backup via Raycast
- **`raycast-package-updates.sh`** - Quick package updates via Raycast

### Utility Scripts
- **`test_maintenance_job.sh`** - Test script for debugging automated jobs

## Environment Loading Configuration

### Shell Environment Setup
All scripts are designed to work with proper environment loading:

```bash
#!/usr/bin/env bash -l
```

The `-l` flag ensures:
- ✅ Login shell behavior
- ✅ Loads `~/.bash_profile`, `~/.bashrc`, `~/.profile`
- ✅ Environment variables are available (PATH, HOMEBREW_PREFIX, etc.)
- ✅ Package managers (brew, npm, pip) are accessible

### Critical Environment Variables
Ensure these are properly configured in your shell profile:
```bash
# Homebrew
export PATH="/opt/homebrew/bin:$PATH"
export HOMEBREW_PREFIX="/opt/homebrew"

# Node.js/npm
export PATH="$PATH:$HOME/.npm-global/bin"

# Python
export PATH="$PATH:$HOME/.local/bin"

# Go
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
```

## Automated Job Configuration
- **Job Name**: `com.user.maintenance.weekly`
- **Schedule**: Every Monday at 9:00 AM
- **Shell**: Runs with login shell (`bash -l`) to ensure environment variables are loaded
- **Working Directory**: `~/Scripts/`
- **Logs**: 
  - stdout: `~/Scripts/maintenance_weekly.log`
  - stderr: `~/Scripts/maintenance_weekly_error.log`

## Files Created
1. **Plist File**: `~/Library/LaunchAgents/com.user.maintenance.weekly.plist`
2. **Log Files**: 
   - `~/Scripts/maintenance_weekly.log`
   - `~/Scripts/maintenance_weekly_error.log`
3. **Test Script**: `~/Scripts/test_maintenance_job.sh`

## Management Commands

### Check Job Status
```bash
launchctl list com.user.maintenance.weekly
```

### Manual Trigger (for testing)
```bash
launchctl start com.user.maintenance.weekly
```

### Stop/Start the Job
```bash
# Stop the job
launchctl unload ~/Library/LaunchAgents/com.user.maintenance.weekly.plist

# Start the job
launchctl load ~/Library/LaunchAgents/com.user.maintenance.weekly.plist
```

### View Logs
```bash
# View stdout log
tail -f ~/Scripts/maintenance_weekly.log

# View stderr log  
tail -f ~/Scripts/maintenance_weekly_error.log

# Run test script to trigger and view logs
~/Scripts/test_maintenance_job.sh
```

## Features
- ✅ Runs with login shell (sources ~/.bash_profile, ~/.bashrc, etc.)
- ✅ Sets working directory to ~/Scripts/
- ✅ Captures both stdout and stderr to separate log files
- ✅ Weekly schedule (Mondays at 9 AM)
- ✅ Automatic loading at user login
- ✅ Environment variables preserved

## Script Usage Guide

### Running Individual Scripts

#### Homebrew Maintenance
```bash
~/Scripts/brew_maintenance.sh
# Updates all Homebrew packages, casks, and cleans up old versions
# Log: ~/Scripts/brew_maintenance.log
```

#### System Cleanup
```bash
~/Scripts/system_cleanup.sh
# Clears system caches, temporary files, and optimizes storage
# Log: ~/Scripts/system_cleanup.log
```

#### Document Backup
```bash
~/Scripts/document_backup.sh
# Creates timestamped backups of Documents, Desktop, and config files
# Backup location: ~/Backups/
# Log: ~/Scripts/document_backup.log
```

#### Package Updates
```bash
~/Scripts/package_updates.sh
# Updates macOS software, App Store apps, and system packages
# Log: ~/Scripts/package_updates.log
```

#### Development Environment Maintenance
```bash
~/Scripts/dev_maintenance.sh
# Updates npm, pip, gems, Rust, Go modules, and cleans dev caches
# Includes health check for common development tools
```

#### System Status Dashboard
```bash
~/Scripts/maintenance_status.sh
# Shows status of all scripts, last run times, and system health
# No log file (displays real-time information)
```

### Running Complete Maintenance Suite
```bash
~/Scripts/run_all_maintenance.sh
# Orchestrates all maintenance tasks with timing information
# Runs: system_cleanup → package_updates → brew_maintenance → document_backup
```

### Raycast Quick Actions
The Raycast scripts provide one-click access to maintenance tasks:
- Type "Brew Maintenance" in Raycast
- Type "System Cleanup" in Raycast
- Type "Document Backup" in Raycast
- Type "Package Updates" in Raycast

## Log Management

### Log Locations
```bash
# Individual script logs
~/Scripts/brew_maintenance.log
~/Scripts/system_cleanup.log
~/Scripts/document_backup.log
~/Scripts/package_updates.log

# Weekly automated job logs
~/Scripts/maintenance_weekly.log        # stdout
~/Scripts/maintenance_weekly_error.log  # stderr
```

### Viewing Logs
```bash
# View recent activity
tail -f ~/Scripts/maintenance_weekly.log

# View errors
tail -f ~/Scripts/maintenance_weekly_error.log

# View all logs at once
ls -la ~/Scripts/*.log

# Check log sizes
du -sh ~/Scripts/*.log
```

### Log Rotation
Logs are automatically managed but you can clean them manually:
```bash
# Archive old logs
mkdir -p ~/Scripts/logs_archive
mv ~/Scripts/*.log ~/Scripts/logs_archive/

# Or simply clear current logs
truncate -s 0 ~/Scripts/*.log
```

## Troubleshooting Guide

### Common Issues and Solutions

#### 1. Scripts Not Running Automatically
**Problem**: Scheduled job isn't executing

**Diagnosis**:
```bash
# Check if job is loaded
launchctl list | grep maintenance

# Check job status
launchctl list com.user.maintenance.weekly
```

**Solutions**:
```bash
# Reload the job
launchctl unload ~/Library/LaunchAgents/com.user.maintenance.weekly.plist
launchctl load ~/Library/LaunchAgents/com.user.maintenance.weekly.plist

# Test manual trigger
launchctl start com.user.maintenance.weekly
```

#### 2. Permission Issues
**Problem**: "Permission denied" errors

**Solutions**:
```bash
# Make all scripts executable
chmod +x ~/Scripts/*.sh

# Fix ownership if needed
chown $(whoami) ~/Scripts/*.sh

# Check script permissions
ls -la ~/Scripts/*.sh
```

#### 3. Environment Variable Issues
**Problem**: Commands not found (brew, npm, pip, etc.)

**Diagnosis**:
```bash
# Test environment in non-login shell
bash -c 'echo $PATH'

# Test environment in login shell
bash -l -c 'echo $PATH'

# Check if tools are accessible
bash -l -c 'which brew npm pip3'
```

**Solutions**:
1. Ensure proper shebang in scripts: `#!/usr/bin/env bash -l`
2. Add missing paths to `~/.bash_profile` or `~/.zshrc`:
   ```bash
   export PATH="/opt/homebrew/bin:$PATH"
   export PATH="$PATH:$HOME/.local/bin"
   ```
3. Source your profile manually:
   ```bash
   source ~/.bash_profile  # or ~/.zshrc
   ```

#### 4. Backup Issues
**Problem**: Backup script fails or creates empty backups

**Diagnosis**:
```bash
# Check backup directory
ls -la ~/Backups/

# Check disk space
df -h ~

# Test backup manually
~/Scripts/document_backup.sh
```

**Solutions**:
```bash
# Create backup directory if missing
mkdir -p ~/Backups

# Check and clean up old backups
find ~/Backups -name "*.tar.gz" -mtime +30 -delete

# Fix permissions
chmod 755 ~/Backups
```

#### 5. Package Manager Issues
**Problem**: Homebrew, npm, or pip updates fail

**Solutions**:
```bash
# Fix Homebrew permissions
sudo chown -R $(whoami) $(brew --prefix)/*

# Update Homebrew itself first
brew update

# Fix npm permissions
npm config set prefix ~/.npm-global

# Update pip itself
python3 -m pip install --upgrade pip
```

#### 6. Log File Issues
**Problem**: Logs not appearing or permission denied

**Solutions**:
```bash
# Check log directory permissions
ls -la ~/Scripts/

# Fix log file permissions
chmod 644 ~/Scripts/*.log

# Create missing log files
touch ~/Scripts/{brew_maintenance,system_cleanup,document_backup,package_updates}.log
```

### Advanced Troubleshooting

#### Debug Mode
Run scripts with debug output:
```bash
# Enable debug mode
bash -x ~/Scripts/run_all_maintenance.sh

# Or add to script temporarily
set -x  # at the beginning of script
set +x  # at the end of script
```

#### Test Environment
Create a test script to verify environment:
```bash
#!/usr/bin/env bash -l
echo "PATH: $PATH"
echo "Brew: $(which brew 2>/dev/null || echo 'Not found')"
echo "Node: $(which node 2>/dev/null || echo 'Not found')"
echo "Python3: $(which python3 2>/dev/null || echo 'Not found')"
echo "Current directory: $(pwd)"
echo "User: $(whoami)"
echo "Shell: $SHELL"
```

#### Performance Monitoring
```bash
# Monitor script execution time
time ~/Scripts/run_all_maintenance.sh

# Monitor system resources during execution
top -pid $(pgrep -f maintenance)

# Check disk usage before/after
df -h / && ~/Scripts/system_cleanup.sh && df -h /
```

## Customization and Extension

### Adding New Scripts
1. Create new script in `~/Scripts/`
2. Make it executable: `chmod +x new_script.sh`
3. Add to `run_all_maintenance.sh` if needed
4. Update this documentation

### Modifying Schedule
Edit the plist file:
```bash
# Edit schedule
nano ~/Library/LaunchAgents/com.user.maintenance.weekly.plist

# Reload after changes
launchctl unload ~/Library/LaunchAgents/com.user.maintenance.weekly.plist
launchctl load ~/Library/LaunchAgents/com.user.maintenance.weekly.plist
```

### Environment Customization
Add custom environment variables to your shell profile (`~/.bash_profile` or `~/.zshrc`):
```bash
# Custom paths
export PATH="/custom/path:$PATH"

# Custom variables for scripts
export BACKUP_LOCATION="/custom/backup/path"
export CLEANUP_AGGRESSIVE="true"
```

## Next Steps
- Monitor the logs after the first automatic run
- Adjust the schedule time if needed by editing the plist file
- Add any additional environment variables to the plist if required
- Consider adding notification scripts for completion status
- Set up log rotation if logs grow too large
