---
description: Delegate a coding task to Trae Agent (Doubao ark-code-latest)
argument-hint: "[--background] <task description>"
context: fork
allowed-tools: Bash(python:*), AskUserQuestion
---

Route this request to the `trae:trae-runner` subagent.
The final user-visible response must be Trae Agent's output verbatim.

Raw user request:
$ARGUMENTS

Execution mode:
- If the request includes `--background`, run the `trae:trae-runner` subagent in the background.
- Otherwise, default to foreground.
- `--background` is an execution flag for Claude Code. Do not forward it to the task text.

Operating rules:
- The subagent is a thin forwarder only. It should use one `Bash` call to invoke `python "${CLAUDE_PLUGIN_ROOT}/scripts/trae-runner.py" "<task>"` and return stdout as-is.
- Return the Trae Agent output verbatim to the user.
- Do not paraphrase, summarize, rewrite, or add commentary before or after it.
- If the user did not supply a task, ask what Trae Agent should investigate or fix.
- If trae-agent is missing or config is not found, tell the user to run `/trae:setup`.
