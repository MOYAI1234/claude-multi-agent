# claude-multi-agent

Connect Claude Code, Codex, and Doubao into a single unified interface — without switching apps.

## Architecture

```
Claude Code (Desktop App)
  ├── /codex:rescue  →  Codex CLI (GPT-5.4, code execution & debugging)
  └── /trae:run      →  Trae Agent (Doubao ark-code-latest, fast tasks)
```

Claude Code acts as the router. You never leave the app.

## Routing Rules

| Trigger | Goes to |
|---------|---------|
| Code changes, multi-file debugging | `/codex:rescue` |
| Image recognition, fixed-format extraction | `/trae:run` |
| Planning, analysis, writing, judgment calls | Claude (handles directly) |

The routing is automatic — Claude decides based on task type and delegates without asking.

## What's in this repo

| Path | Description |
|------|-------------|
| `plugins/trae/` | Claude Code plugin for Trae Agent (Doubao) |
| `trae_config.example.json` | Trae Agent config template |
| `CLAUDE.md.template` | Routing rules for your global `~/.claude/CLAUDE.md` |
| `install.sh` | One-command installer |

> The Codex plugin is maintained by OpenAI at [openai/codex-plugin-cc](https://github.com/openai/codex-plugin-cc).

## Requirements

- Claude Code desktop app
- [Codex CLI](https://github.com/openai/codex) + ChatGPT subscription or OpenAI API key
- Python 3.8+
- Volcengine API key ([console.volcengine.com](https://console.volcengine.com))

## Installation

### Step 1 — Install Codex plugin

In Claude Code, run:
```
/plugin marketplace add openai/codex-plugin-cc
/plugin install codex@openai-codex
/reload-plugins
/codex:setup
```

> If your Claude Code version doesn't support `/plugin`, see [manual install](docs/manual-install.md).

### Step 2 — Install Trae plugin

```bash
# Install trae-agent
pip install git+https://github.com/bytedance/trae-agent.git

# Clone this repo and run installer
git clone https://github.com/MOYAI1234/claude-multi-agent
cd claude-multi-agent
bash install.sh
```

Edit `~/.trae_config.json` and fill in your Volcengine API key.

### Step 3 — Add routing rules

Append `CLAUDE.md.template` to your global `~/.claude/CLAUDE.md`:

```bash
cat CLAUDE.md.template >> ~/.claude/CLAUDE.md
```

### Step 4 — Restart Claude Code

Restart the desktop app, then verify:
```
/trae:setup
/codex:setup
```

## Usage

```
/trae:run 识别这张截图里的文字
/trae:run 把这个 JSON 转成 CSV 格式

/codex:rescue 找出为什么这个函数返回 null
/codex:rescue 重构 auth 模块，提取公共逻辑
/codex:review
```

Or just describe your task naturally — Claude will route it automatically.

## License

MIT
