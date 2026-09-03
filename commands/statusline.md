---
description: Install the status line (model, context bar, cost, diff, branch, project)
allowed-tools: Bash
---

Run the installer, then show the user the preview line it prints:

```
bash "${CLAUDE_PLUGIN_ROOT}/scripts/install.sh"
```

Then tell them, in one line, to restart Claude Code for it to appear.
Do not edit their settings.json yourself — the script does it and keeps a backup.
