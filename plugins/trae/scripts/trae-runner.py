"""
Trae Agent runner script for Claude Code plugin.
Usage: python trae-runner.py "task description"
"""

import sys
import os

CONFIG_FILE = os.path.join(os.path.expanduser("~"), ".trae_config.json")


def main():
    if len(sys.argv) < 2:
        print("Error: no task provided.", file=sys.stderr)
        sys.exit(1)

    task = sys.argv[1]

    try:
        from trae_agent.cli import cli
    except ImportError:
        print("Error: trae-agent is not installed. Run: pip install git+https://github.com/bytedance/trae-agent.git", file=sys.stderr)
        sys.exit(1)

    if not os.path.exists(CONFIG_FILE):
        print(f"Error: config not found at {CONFIG_FILE}. Run /trae:setup to diagnose.", file=sys.stderr)
        sys.exit(1)

    cli(["run", "--config-file", CONFIG_FILE, "--provider", "doubao", task], standalone_mode=True)


if __name__ == "__main__":
    main()
