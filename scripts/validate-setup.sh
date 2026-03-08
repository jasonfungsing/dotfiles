#!/usr/bin/env bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_DIR="$(dirname "$SCRIPT_DIR")"
PASSED=0
FAILED=0

check() {
    if [ $? -eq 0 ]; then
        echo "✓ $1"
        ((PASSED++))
    else
        echo "✗ $1"
        ((FAILED++))
    fi
}

section() {
    echo ""
    echo "═══ $1 ═══"
}

section "Shell Configuration"

[ -L "$HOME/.zshrc" ] && check "zshrc symlink exists"
[ -L "$HOME/.vimrc" ] && check "vimrc symlink exists"
[ -L "$HOME/.tmux.conf" ] && check "tmux.conf symlink exists"
[ -L "$HOME/.gitconfig" ] && check "gitconfig symlink exists"

section "Shell Environment"

echo $SHELL | grep -q zsh && check "Zsh is default shell"
command -v zsh &> /dev/null && check "Zsh is installed"
[ -d "$HOME/.oh-my-zsh" ] && check "Oh-My-Zsh is installed"

section "Homebrew"

command -v brew &> /dev/null && check "Homebrew is installed"
brew --version | grep -q "Homebrew" && check "Homebrew is functional"

section "Key Packages"

command -v git &> /dev/null && check "Git is installed"
command -v tmux &> /dev/null && check "tmux is installed"
command -v vim &> /dev/null && check "Vim is installed"
command -v kubectl &> /dev/null && check "kubectl is installed"
command -v docker &> /dev/null && check "Docker is installed"

section "Development Tools"

command -v node &> /dev/null && check "Node.js is installed"
command -v python3 &> /dev/null && check "Python 3 is installed"
command -v go &> /dev/null && check "Go is installed"

section "Summary"

echo ""
echo "Validation Results:"
echo "  ✓ Passed: $PASSED"
echo "  ✗ Failed: $FAILED"
echo ""

if [ $FAILED -eq 0 ]; then
    echo "Setup validation successful!"
    exit 0
else
    echo "Some checks failed. Review the output above."
    exit 1
fi
