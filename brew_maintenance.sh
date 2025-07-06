#!/usr/bin/env bash -l
# Load Homebrew environment for non-interactive shells
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "❌ brew not found at /opt/homebrew/bin/brew"
  exit 1
fi

# Homebrew Weekly Maintenance Script
echo "🍺 Starting Homebrew Weekly Maintenance..."
echo "========================================"

# Update Homebrew
echo "📥 Updating Homebrew..."
brew update

# Upgrade all packages
echo "⬆️  Upgrading packages..."
brew upgrade

# Clean up old versions and cache
echo "🧹 Cleaning up..."
brew cleanup --prune=7

# Run health check
echo "🩺 Running health check..."
brew doctor

# Show summary
echo "========================================"
echo "✅ Homebrew maintenance complete!"
echo "📊 Current status:"
brew list --versions | wc -l | xargs echo "   Installed packages:"
du -sh $(brew --cache) 2>/dev/null | xargs echo "   Cache size:" || echo "   Cache size: Empty"
echo "🕐 Completed at: $(date)"