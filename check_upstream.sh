#!/usr/bin/env bash
# check_upstream.sh — does upstream Sateezg/codex-bridge have commits the fork lacks?
set -euo pipefail
cd "$(dirname "$0")"
BR="$(git symbolic-ref --short HEAD)"
git fetch -q upstream
UBR=""
git rev-parse -q --verify upstream/main >/dev/null 2>&1 && UBR=main
[ -z "$UBR" ] && git rev-parse -q --verify upstream/master >/dev/null 2>&1 && UBR=master
[ -n "$UBR" ] || { echo "$(date -Is) ERROR no upstream/main or upstream/master" >> UPSTREAM_STATUS.txt; exit 1; }
BEHIND="$(git rev-list --count "$BR..upstream/$UBR")"
AHEAD="$(git rev-list --count "upstream/$UBR..$BR")"
echo "$(date -Is) branch=$BR upstream_new_commits=$BEHIND fork_ahead=$AHEAD" >> UPSTREAM_STATUS.txt
