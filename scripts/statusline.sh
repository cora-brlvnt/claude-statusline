#!/usr/bin/env bash
in=$(cat)
eval "$(jq -r '
  @sh "model=\(.model.display_name // "?")
       dir=\(.workspace.current_dir // ".")
       proj=\(.workspace.project_dir // .workspace.current_dir // "" | split("/") | last // "")
       pct=\(.context_window.used_percentage // -1 | floor)
       tok=\(.context_window.total_input_tokens // 0)
       cost=\(.cost.total_cost_usd // 0)
       add=\(.cost.total_lines_added // 0)
       del=\(.cost.total_lines_removed // 0)"' <<<"$in")"

sep=$'\033[38;5;103m | \033[0m'
printf '\033[1;38;5;45m%s\033[0m' "$model"

if [ "$pct" -ge 0 ]; then
  cells=10; on=$(( (pct * cells + 50) / 100 ))
  [ "$on" -gt "$cells" ] && on=$cells
  printf '%s[\033[48;5;194m%*s\033[48;5;237m%*s\033[0m]' "$sep" "$on" "" $((cells-on)) ""
  printf ' \033[38;5;253m%s%%\033[0m' "$pct"
  # k-suffix once past 1000 tokens; below that the raw count is more useful
  if [ "$tok" -ge 1000 ]; then printf ' \033[38;5;193m%dk\033[0m' $((tok/1000))
  elif [ "$tok" -gt 0 ]; then printf ' \033[38;5;193m%d\033[0m' "$tok"; fi
fi

printf '%s\033[38;5;222m$%.2f\033[0m' "$sep" "$cost"
[ "$add$del" != "00" ] && printf '%s\033[38;5;114m+%s\033[0m\033[38;5;103m/\033[0m\033[38;5;210m-%s\033[0m' "$sep" "$add" "$del"
branch=$(git -C "$dir" branch --show-current 2>/dev/null)
[ -n "$branch" ] && printf '%s\033[38;5;117m%s\033[0m' "$sep" "$branch"
[ -n "$proj" ] && printf '%s\033[38;5;183m%s\033[0m' "$sep" "$proj"

# ponytail badge, only if that plugin is installed
pt=$(ls -d "${CLAUDE_CONFIG_DIR:-$HOME/.claude}"/plugins/cache/ponytail/ponytail/*/hooks/ponytail-statusline.sh 2>/dev/null | sort -V | tail -1)
if [ -n "$pt" ]; then
  badge=$(printf '%s' "$in" | bash "$pt" 2>/dev/null)
  [ -n "$badge" ] && printf '%s%s' "$sep" "$badge"
fi
exit 0
