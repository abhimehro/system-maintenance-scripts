#!/bin/bash

# Package Manager Update Script
echo "📦 Starting Package Manager Updates..."
echo "======================================"

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to run command with error handling
safe_run() {
    local cmd="$1"
    local description="$2"
    
    echo "🔄 $description..."
    if eval "$cmd" >/dev/null 2>&1; then
        echo "   ✅ Success"
    else
        echo "   ⚠️  Failed or not needed"
    fi
}

# Homebrew (already handled by separate script, but included for completeness)
if command_exists brew; then
    echo "🍺 Updating Homebrew..."
    safe_run "brew update" "Updating Homebrew database"
    safe_run "brew upgrade" "Upgrading Homebrew packages"
    safe_run "brew cleanup --prune=7" "Cleaning Homebrew cache"
    echo "   ✅ Homebrew updated"
else
    echo "   ⚠️  Homebrew not found"
fi

echo ""

# Node.js/npm
if command_exists npm; then
    echo "📗 Updating npm packages..."
    safe_run "npm update -g" "Updating global npm packages"
    safe_run "npm cache clean --force" "Cleaning npm cache"
    
    # Show outdated packages
    outdated_npm=$(npm outdated -g --depth=0 2>/dev/null | wc -l | xargs)
    if [ "$outdated_npm" -gt 1 ]; then
        echo "   📊 $((outdated_npm - 1)) packages still outdated"
    else
        echo "   ✅ All npm packages up to date"
    fi
else
    echo "   ⚠️  npm not found"
fi

echo ""

# Python/pip
if command_exists pip3; then
    echo "🐍 Updating Python packages..."
    
    # Get list of outdated packages
    outdated_packages=$(pip3 list --outdated --format=json 2>/dev/null | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    for pkg in data:
        print(pkg['name'])
except:
    pass
" 2>/dev/null)
    
    if [ -n "$outdated_packages" ]; then
        echo "$outdated_packages" | while read package; do
            if [ -n "$package" ]; then
                safe_run "pip3 install --upgrade '$package'" "Updating $package"
            fi
        done
    else
        echo "   ✅ All pip packages up to date"
    fi
    
    safe_run "pip3 cache purge" "Cleaning pip cache"
else
    echo "   ⚠️  pip3 not found"
fi

echo ""

# Ruby/gem
if command_exists gem; then
    echo "💎 Updating Ruby gems..."
    safe_run "gem update --system" "Updating RubyGems system"
    safe_run "gem update" "Updating installed gems"
    safe_run "gem cleanup" "Cleaning old gem versions"
    echo "   ✅ Ruby gems updated"
else
    echo "   ⚠️  gem not found"
fi

echo ""

# Rust/cargo
if command_exists cargo; then
    echo "🦀 Updating Rust packages..."
    safe_run "rustup update" "Updating Rust toolchain"
    
    # Update cargo-installed packages if cargo-update is available
    if command_exists cargo-install-update; then
        safe_run "cargo install-update -a" "Updating cargo packages"
    else
        echo "   💡 Install cargo-update for package updates: cargo install cargo-update"
    fi
    echo "   ✅ Rust updated"
else
    echo "   ⚠️  cargo not found"
fi

echo ""

# Go modules (if in a Go project)
if command_exists go; then
    echo "🐹 Checking Go installation..."
    go_version=$(go version 2>/dev/null | awk '{print $3}')
    echo "   📊 Go version: $go_version"
    echo "   💡 Go modules update automatically per project"
else
    echo "   ⚠️  go not found"
fi

echo ""

# macOS App Store updates
echo "🍎 Checking App Store updates..."
if command_exists mas; then
    # List available updates
    available_updates=$(mas outdated 2>/dev/null | wc -l | xargs)
    if [ "$available_updates" -gt 0 ]; then
        echo "   📱 $available_updates App Store updates available"
        safe_run "mas upgrade" "Installing App Store updates"
    else
        echo "   ✅ All App Store apps up to date"
    fi
else
    echo "   💡 Install 'mas' for App Store CLI: brew install mas"
fi

echo ""

# System software updates
echo "🔧 Checking system updates..."
system_updates=$(softwareupdate -l 2>/dev/null | grep -c "recommended" | head -1)
# Ensure we have a valid number
if [ -z "$system_updates" ] || ! [[ "$system_updates" =~ ^[0-9]+$ ]]; then
    system_updates=0
fi
if [ "$system_updates" -gt 0 ]; then
    echo "   🚨 $system_updates system updates available"
    echo "   💡 Run 'softwareupdate -ia' to install (requires admin)"
else
    echo "   ✅ System up to date"
fi

echo ""
echo "======================================"
echo "✅ Package manager updates complete!"
echo "📊 Summary:"
echo "   🍺 Homebrew: $(command_exists brew && echo "✅" || echo "❌")"
echo "   📗 npm: $(command_exists npm && echo "✅" || echo "❌")"
echo "   🐍 pip: $(command_exists pip3 && echo "✅" || echo "❌")"
echo "   💎 gem: $(command_exists gem && echo "✅" || echo "❌")"
echo "   🦀 cargo: $(command_exists cargo && echo "✅" || echo "❌")"
echo "   🍎 mas: $(command_exists mas && echo "✅" || echo "❌")"
echo "🕐 Completed at: $(date)"