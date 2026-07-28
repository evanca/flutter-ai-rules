#!/usr/bin/env bash
set -euo pipefail

readonly DEFAULT_RULES_REPO="https://github.com/evanca/flutter-ai-rules"
readonly CONFIRMATION="DELETE EXISTING RULES"
readonly TARGETS=(
  "${CODEX_RULES_PATH:-$HOME/.codex/AGENTS.md}"
  "${CLAUDE_RULES_PATH:-$HOME/.claude/CLAUDE.md}"
  "${GEMINI_RULES_PATH:-$HOME/.gemini/GEMINI.md}"
)

read -r -p "Rules repository [$DEFAULT_RULES_REPO]: " rules_repo
rules_repo="${rules_repo:-$DEFAULT_RULES_REPO}"

echo "WARNING: This will replace all existing global rules for:"
printf '  - %s\n' "${TARGETS[@]}"
echo
echo "They will be replaced with AGENTS.md from:"
echo "  $rules_repo"
echo
read -r -p "Type '$CONFIRMATION' to continue: " response

if [[ "$response" != "$CONFIRMATION" ]]; then
  echo "Cancelled. No files were changed."
  exit 1
fi

checkout_dir="$(mktemp -d)"
trap 'rm -rf "$checkout_dir"' EXIT

git clone --depth 1 --quiet "$rules_repo" "$checkout_dir/repo"
rules_file="$checkout_dir/repo/AGENTS.md"

if [[ ! -s "$rules_file" ]]; then
  echo "Error: the repository's root AGENTS.md is missing or empty." >&2
  exit 1
fi

for target in "${TARGETS[@]}"; do
  mkdir -p "$(dirname "$target")"
  install -m 0644 "$rules_file" "$target"
  echo "Installed $target"
done

echo "Global rules synchronized."
