---
description: Check whether trae-agent and Doubao config are ready
argument-hint: ''
allowed-tools: Bash(python:*)
---

Run:

```bash
python "${CLAUDE_PLUGIN_ROOT}/scripts/trae-setup.py"
```

Present the output to the user in a readable format.
- If `ready` is true, confirm everything is set up and suggest trying `/trae:run`.
- If `ready` is false, show the `next_steps` items clearly so the user knows what to fix.
