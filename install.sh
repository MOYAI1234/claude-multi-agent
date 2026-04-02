#!/usr/bin/env bash
# claude-multi-agent installer
# Installs the trae plugin and registers it in Claude Code
# Usage: bash install.sh

set -e

PLUGIN_SRC="$(cd "$(dirname "$0")/plugins/trae" && pwd)"
CLAUDE_DIR="$HOME/.claude"
PLUGIN_DST="$CLAUDE_DIR/plugins/cache/local/trae/1.0.0"
SETTINGS="$CLAUDE_DIR/settings.json"
INSTALLED="$CLAUDE_DIR/plugins/installed_plugins.json"
CONFIG_DST="$HOME/.trae_config.json"

echo "=== claude-multi-agent installer ==="

# 1. Copy plugin files
echo "[1/4] Copying trae plugin files..."
mkdir -p "$PLUGIN_DST"
cp -r "$PLUGIN_SRC/." "$PLUGIN_DST/"
echo "      → $PLUGIN_DST"

# 2. Copy config template if not already present
echo "[2/4] Setting up trae config..."
if [ -f "$CONFIG_DST" ]; then
  echo "      → $CONFIG_DST already exists, skipping"
else
  cp "$(dirname "$0")/trae_config.example.json" "$CONFIG_DST"
  echo "      → Created $CONFIG_DST"
  echo "      ⚠ Edit $CONFIG_DST and replace YOUR_VOLCENGINE_API_KEY"
fi

# 3. Register in installed_plugins.json
echo "[3/4] Registering plugin..."
WIN_PATH=$(echo "$PLUGIN_DST" | sed 's|/c/|C:\\|; s|/|\\|g')
python3 - <<PYEOF
import json, os, sys
path = os.path.expanduser("~/.claude/plugins/installed_plugins.json")
with open(path) as f:
    data = json.load(f)
key = "trae@local"
if key not in data["plugins"]:
    data["plugins"][key] = [{
        "scope": "user",
        "installPath": r"$WIN_PATH",
        "version": "1.0.0",
        "installedAt": "2026-04-02T00:00:00.000Z",
        "lastUpdated": "2026-04-02T00:00:00.000Z",
        "gitCommitSha": "local"
    }]
    with open(path, "w") as f:
        json.dump(data, f, indent=2)
    print("      → Registered trae@local")
else:
    print("      → Already registered, skipping")
PYEOF

# 4. Enable in settings.json
echo "[4/4] Enabling plugin in settings.json..."
python3 - <<PYEOF
import json, os
path = os.path.expanduser("~/.claude/settings.json")
with open(path) as f:
    data = json.load(f)
if not data.get("enabledPlugins", {}).get("trae@local"):
    data.setdefault("enabledPlugins", {})["trae@local"] = True
    with open(path, "w") as f:
        json.dump(data, f, indent=2)
    print("      → Enabled trae@local")
else:
    print("      → Already enabled, skipping")
PYEOF

echo ""
echo "=== Done! ==="
echo "Next steps:"
echo "  1. Edit ~/.trae_config.json — fill in your Volcengine API key"
echo "  2. pip install git+https://github.com/bytedance/trae-agent.git"
echo "  3. Restart Claude Code desktop app"
echo "  4. Run /trae:setup to verify"
