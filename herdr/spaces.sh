#!/usr/bin/env bash
# Create the standing herdr spaces. herdr restores workspaces from session.json
# on every restart, so this only has to run on a fresh machine, or after the
# session state is lost. Creating a space that already exists is skipped, so
# running it again is safe.

set -euo pipefail

SPACES=(Logs Agents Reviews Management)

if ! herdr workspace list > /dev/null 2>&1; then
  echo "ERROR: no herdr server is running. Start it with 'herdr' first."
  exit 1
fi

existing=$(herdr workspace list | python3 -c 'import json,sys; print("\n".join(w["label"] for w in json.load(sys.stdin)["result"]["workspaces"]))')

for space in "${SPACES[@]}"; do
  if grep -qxF "$space" <<< "$existing"; then
    echo "$space: already there"
  else
    herdr workspace create --label "$space" --cwd "$HOME" --no-focus > /dev/null
    echo "$space: created"
  fi
done
