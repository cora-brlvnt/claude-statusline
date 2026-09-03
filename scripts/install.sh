#!/usr/bin/env bash
# Copies statusline.sh into the user's Claude config and points settings.json at it.
set -euo pipefail
here=$(cd "$(dirname "$0")" && pwd)
DIR="${CLAUDE_CONFIG_DIR:-$HOME/.claude}"

command -v jq >/dev/null || { echo "need jq: brew install jq  (or apt install jq)"; exit 1; }
command -v python3 >/dev/null || { echo "need python3"; exit 1; }
[ -d "$DIR" ] || { echo "no $DIR found"; exit 1; }

install -m 755 "$here/statusline.sh" "$DIR/statusline.sh"

python3 - "$DIR" <<'PY'
import json, pathlib, shutil, sys
p = pathlib.Path(sys.argv[1]) / "settings.json"
d = json.loads(p.read_text()) if p.exists() else {}
if p.exists(): shutil.copy(p, p.with_suffix(".json.bak"))
d["statusLine"] = {"type": "command", "command": f'bash "{p.parent}/statusline.sh"'}
p.write_text(json.dumps(d, indent=2) + "\n")
print(f"patched {p} (backup: {p.with_suffix('.json.bak').name})")
PY

echo "preview:"
printf '{"model":{"display_name":"Opus 5"},"workspace":{"current_dir":"%s","project_dir":"%s"},"context_window":{"used_percentage":31.4,"total_input_tokens":319000},"cost":{"total_cost_usd":43.62,"total_lines_added":1136,"total_lines_removed":63}}' "$PWD" "$PWD" | bash "$DIR/statusline.sh"
echo
