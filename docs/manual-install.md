# Manual Plugin Installation

If your Claude Code version doesn't support the `/plugin` command (desktop app on older versions), follow these steps to install plugins manually by editing the registry files directly.

## How Claude Code's plugin system works

Plugins are just local files. Three JSON files control what's installed:

| File | Role |
|------|------|
| `~/.claude/plugins/known_marketplaces.json` | "I know this marketplace exists" |
| `~/.claude/plugins/installed_plugins.json` | "This plugin is at this path" |
| `~/.claude/settings.json` | "Enable this plugin in sessions" |

## Manually installing the Codex plugin (openai/codex-plugin-cc)

### 1. Clone the repo into the marketplaces directory

```bash
git clone https://github.com/openai/codex-plugin-cc \
  ~/.claude/plugins/marketplaces/openai-codex
```

### 2. Get the commit SHA

```bash
cd ~/.claude/plugins/marketplaces/openai-codex
git rev-parse --short HEAD   # e.g. 8e403f9
git rev-parse HEAD           # full SHA
```

### 3. Copy the plugin to cache

```bash
SHA=$(git rev-parse --short HEAD)
mkdir -p ~/.claude/plugins/cache/openai-codex/codex/$SHA
cp -r plugins/codex/. ~/.claude/plugins/cache/openai-codex/codex/$SHA/
```

### 4. Register in `known_marketplaces.json`

Add this entry:

```json
"openai-codex": {
  "source": { "source": "github", "repo": "openai/codex-plugin-cc" },
  "installLocation": "C:\\Users\\YOU\\.claude\\plugins\\marketplaces\\openai-codex",
  "lastUpdated": "2026-04-02T00:00:00.000Z"
}
```

### 5. Register in `installed_plugins.json`

Add this entry inside `"plugins"`:

```json
"codex@openai-codex": [
  {
    "scope": "user",
    "installPath": "C:\\Users\\YOU\\.claude\\plugins\\cache\\openai-codex\\codex\\SHA_HERE",
    "version": "1.0.2",
    "installedAt": "2026-04-02T00:00:00.000Z",
    "lastUpdated": "2026-04-02T00:00:00.000Z",
    "gitCommitSha": "FULL_SHA_HERE"
  }
]
```

### 6. Enable in `settings.json`

Add to `enabledPlugins`:

```json
"codex@openai-codex": true
```

### 7. Restart Claude Code and verify

```
/codex:setup
```

---

## Notes

- Replace `YOU` with your Windows username and `SHA_HERE` with the actual commit SHA.
- The `installPath` must use Windows backslash format (`C:\\Users\\...`).
- If you forked the repo (e.g. to `YOURGITHUB/codex-plugin-cc`), replace the repo field accordingly.
