#!/bin/bash

# Development Environment Maintenance Script
echo "⚙️ Starting Dev Environment Maintenance..."
echo "========================================"

echo "📦 Updating package managers..."

# Update npm packages globally
if command -v npm &> /dev/null; then
    echo "🟢 Updating npm and global packages..."
    npm update -g 2>/dev/null
    npm_outdated=$(npm outdated -g --depth=0 2>/dev/null | wc -l)
    echo "   npm: Updated global packages ($npm_outdated were outdated)"
else
    echo "   npm: Not installed"
fi

# Update yarn if installed
if command -v yarn &> /dev/null; then
    echo "🧶 Updating yarn..."
    yarn global upgrade 2>/dev/null
    echo "   yarn: Global packages updated"
else
    echo "   yarn: Not installed"
fi

# Update pip packages
if command -v pip3 &> /dev/null; then
    echo "🐍 Updating pip packages..."
    pip3 list --outdated --format=freeze 2>/dev/null | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U 2>/dev/null
    pip_outdated=$(pip3 list --outdated 2>/dev/null | wc -l)
    echo "   pip: Updated packages ($pip_outdated were outdated)"
else
    echo "   pip3: Not installed"
fi

# Update Ruby gems if installed
if command -v gem &> /dev/null; then
    echo "💎 Updating Ruby gems..."
    gem update --system 2>/dev/null
    gem update 2>/dev/null
    echo "   gems: Updated"
else
    echo "   gem: Not installed"
fi

# Update Rust if installed
if command -v rustup &> /dev/null; then
    echo "🦀 Updating Rust..."
    rustup update 2>/dev/null
    echo "   Rust: Updated"
else
    echo "   rustup: Not installed"
fi

# Update Go modules in common directories
echo ""
echo "🔧 Cleaning development caches..."

# Clean Go module cache
if command -v go &> /dev/null; then
    go clean -modcache 2>/dev/null
    echo "   Go module cache cleaned"
fi

# Clean Xcode derived data
if [ -d "$HOME/Library/Developer/Xcode/DerivedData" ]; then
    rm -rf "$HOME/Library/Developer/Xcode/DerivedData"/* 2>/dev/null
    echo "   Xcode derived data cleaned"
fi

# Clean VS Code extensions cache
if [ -d "$HOME/.vscode/extensions" ]; then
    find "$HOME/.vscode/extensions" -name "*.log" -delete 2>/dev/null
    echo "   VS Code extension logs cleaned"
fi

echo ""
echo "🔍 Development environment health check..."

# Check for common development tools
tools=("git" "node" "python3" "code" "docker")
for tool in "${tools[@]}"; do
    if command -v "$tool" &> /dev/null; then
        version=$(command "$tool" --version 2>/dev/null | head -1)
        echo "   ✅ $tool: $version"
    else
        echo "   ❌ $tool: Not installed"
    fi
done

echo ""
echo "========================================"
echo "✅ Dev environment maintenance complete!"
echo "🕐 Completed at: $(date)"
echo "📝 Next maintenance: $(date -v+1w '+%A, %B %d at %I:%M %p')"