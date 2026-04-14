#!/usr/bin/env bash
# Extra configuration that can't be done through Homebrew

set -euo pipefail

echo "Setting up gitleaks pre-commit hook..."

if ! command -v gitleaks &> /dev/null; then
  echo "ERROR: gitleaks is not installed. Run 'brew install gitleaks' first."
  exit 1
fi

EXISTING_HOOKS_PATH=$(git config --global core.hooksPath 2>/dev/null || true)
if [ -n "$EXISTING_HOOKS_PATH" ] && [ "$EXISTING_HOOKS_PATH" != "$HOME/.git-hooks" ]; then
  echo "WARNING: core.hooksPath is already set to '$EXISTING_HOOKS_PATH'."
  echo "This script will overwrite it to '$HOME/.git-hooks'."
  read -rp "Continue? [y/N] " confirm
  if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
    echo "Aborted."
    exit 1
  fi
fi

mkdir -p ~/.git-hooks
cat > ~/.git-hooks/pre-commit << 'HOOK'
#!/usr/bin/env bash
# Run gitleaks on staged changes
if ! command -v gitleaks &> /dev/null; then
  echo "WARNING: gitleaks not found, skipping secret scan"
  exit 0
fi
gitleaks git --pre-commit --staged --verbose

# Chain to repo-local pre-commit hook if it exists
LOCAL_HOOK="$(git rev-parse --git-dir)/hooks/pre-commit"
if [ -x "$LOCAL_HOOK" ]; then
  exec "$LOCAL_HOOK" "$@"
fi
HOOK
chmod +x ~/.git-hooks/pre-commit
git config --global core.hooksPath ~/.git-hooks
