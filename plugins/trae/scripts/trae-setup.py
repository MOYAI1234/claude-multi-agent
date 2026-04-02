"""
Trae Agent setup check script for Claude Code plugin.
Outputs JSON status.
"""

import sys
import os
import json

CONFIG_FILE = os.path.join(os.path.expanduser("~"), ".trae_config.json")


def main():
    result = {
        "ready": False,
        "python": {"available": True, "detail": sys.version.split()[0]},
        "trae_agent": {"available": False, "detail": ""},
        "config": {"available": False, "path": CONFIG_FILE},
        "next_steps": [],
    }

    try:
        import trae_agent
        result["trae_agent"]["available"] = True
        result["trae_agent"]["detail"] = getattr(trae_agent, "__version__", "installed")
    except ImportError:
        result["trae_agent"]["detail"] = "not installed"
        result["next_steps"].append("Run: pip install git+https://github.com/bytedance/trae-agent.git")

    if os.path.exists(CONFIG_FILE):
        result["config"]["available"] = True
        try:
            with open(CONFIG_FILE) as f:
                cfg = json.load(f)
            provider = cfg.get("default_provider", "?")
            models = cfg.get("model_providers", {})
            model_name = models.get(provider, {}).get("model", "?")
            result["config"]["detail"] = f"provider={provider}, model={model_name}"
        except Exception as e:
            result["config"]["detail"] = f"parse error: {e}"
    else:
        result["next_steps"].append(f"Create config at {CONFIG_FILE}")

    result["ready"] = result["trae_agent"]["available"] and result["config"]["available"]
    print(json.dumps(result, indent=2, ensure_ascii=False))


if __name__ == "__main__":
    main()
