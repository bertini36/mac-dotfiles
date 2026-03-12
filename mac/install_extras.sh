#!/usr/bin/env bash
# Packages that can't be installed through Homebrew

set -euo pipefail

echo "Installing Claude CLI..."
curl -fsSL https://claude.ai/install.sh | bash
