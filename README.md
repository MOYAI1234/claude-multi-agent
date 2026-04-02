# claude-multi-agent

Connect Claude Code, Codex, and Doubao into a single unified interface — without switching apps.

## Architecture

```
Claude Code (Desktop App)
  ├── /codex:rescue  →  Codex CLI (GPT-5.4, code execution & debugging)
  └── /trae:run      →  Trae Agent (Doubao ark-code-latest, fast tasks)
```

Claude Code acts as the router. You never leave the app.

## How Routing Works

Routing is enforced at the **mechanism level** via a `UserPromptSubmit` hook — not by relying on Claude's memory or instructions.

```
User sends message
      ↓
UserPromptSubmit hook fires  ← happens BEFORE Claude reads the message
      ↓
routing_check.py classifies the task (keyword rules)
      ↓
Injects routing suggestion into Claude's context
      ↓
Claude presents recommendation → user confirms
      ↓
Routes to the right executor
```

This matters because text instructions in `CLAUDE.md` compete with Claude's trained instinct to answer directly. A hook runs before Claude even sees the message — Claude cannot skip it.

### Routing Rules

| Task type | Recommended executor |
|-----------|---------------------|
| Image recognition, screenshots, OCR | `/trae:run` (Doubao) |
| Code changes, multi-file debugging, implementation | `/codex:rescue` (Codex) |
| Explicit: "让 Codex 处理" / "用豆包" | Direct route, no confirmation |
| Planning, analysis, writing, judgment calls | Claude handles directly |

Priority: explicit override → Trae → Codex → Claude self.

When Claude routes to itself, the hook exits silently — no interruption.

## What's in this repo

| Path | Description |
|------|-------------|
| `plugins/trae/` | Claude Code plugin for Trae Agent (Doubao) |
| `trae_config.example.json` | Trae Agent config template |
| `routing_check.py` | Hook script — classifies tasks and injects routing suggestions |
| `CLAUDE.md.template` | Minimal routing config for `~/.claude/CLAUDE.md` (3 lines, no logic) |
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

> If your Claude Code version does not support `/plugin`, see [manual install](docs/manual-install.md).

### Step 2 — Install Trae plugin

```bash
pip install git+https://github.com/bytedance/trae-agent.git

git clone https://github.com/MOYAI1234/claude-multi-agent
cd claude-multi-agent
bash install.sh
```

Edit `~/.trae_config.json` and fill in your Volcengine API key.

### Step 3 — Set up the routing hook

Copy the routing script:

```bash
cp routing_check.py ~/.claude/routing_check.py
```

Add to `~/.claude/settings.json`:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "hooks": [
          {
            "type": "command",
            "command": "python ~/.claude/routing_check.py",
            "timeout": 5,
            "statusMessage": "Routing check..."
          }
        ]
      }
    ]
  }
}
```

> On Windows, use the full path: `python C:/Users/<you>/.claude/routing_check.py`

### Step 4 — Add minimal routing config to CLAUDE.md

```bash
cat CLAUDE.md.template >> ~/.claude/CLAUDE.md
```

The template is 3 lines — routing logic lives in the hook script, not in text instructions.

### Step 5 — Restart Claude Code

```
/trae:setup
/codex:setup
```

## Usage

```
# Explicit routing
/trae:run 识别这张截图里的文字
/codex:rescue 重构 auth 模块，提取公共逻辑

# Natural language — hook suggests routing automatically
"分析这张截图"          →  hook recommends /trae:run
"修复这个 null bug"     →  hook recommends /codex:rescue
"写一份月度复盘报告"    →  Claude handles directly, hook stays silent
```

## Why hook instead of CLAUDE.md instructions?

| Approach | Reliability | Reason |
|----------|-------------|--------|
| Text instructions in CLAUDE.md | Unreliable | Competes with Claude's trained instinct to answer directly |
| `UserPromptSubmit` hook | Reliable | Runs at the process level before Claude processes the message |

The hook approach moves routing from Claude's "memory" to executable code.

## License

MIT
