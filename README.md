# Claude Code status line

```
Opus 5 (1M context) | [===       ] 31% 319k | $43.62 | +1136/-63 | main | my-project | [PONYTAIL]
```

Model · context bar with % and tokens · session cost · lines added/removed · git branch · project ·
ponytail level (only if that plugin is installed).

## Install

```
/plugin marketplace add cora-brlvnt/claude-statusline
/plugin install statusline@statusline
/statusline
```

Restart Claude Code. `/statusline` copies `statusline.sh` into your Claude config dir and sets
`statusLine` in `settings.json`, keeping a `settings.json.bak`.

No plugin: `bash scripts/install.sh` does the same thing.

Requires `jq` and `python3`. Honors `CLAUDE_CONFIG_DIR`. Colors: edit the `38;5;` / `48;5;` codes
in `scripts/statusline.sh`.
