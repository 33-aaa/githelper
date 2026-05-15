#!/usr/bin/env bash
# Generate a markdown changelog from git commit history, grouped by date.
# Usage: ./generate_changelog.sh [--since <date>] [--until <date>] [--branch <branch>] [--output <file>]
#
# Examples:
#   ./generate_changelog.sh --since "2026-05-10"
#   ./generate_changelog.sh --since "3 days ago"
#   ./generate_changelog.sh --since "last monday" --until "today"
#   ./generate_changelog.sh --since "v1.0" --output CHANGELOG.md

set -euo pipefail

SINCE=""
UNTIL=""
BRANCH="HEAD"
OUTPUT=""

usage() {
    sed -n 's/^# //p' "$0"
    exit 1
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --since)  SINCE="$2"; shift 2 ;;
        --until)  UNTIL="$2"; shift 2 ;;
        --branch) BRANCH="$2"; shift 2 ;;
        --output) OUTPUT="$2"; shift 2 ;;
        -h|--help) usage ;;
        *) echo "Unknown option: $1"; usage ;;
    esac
done

if [[ -z "$SINCE" ]]; then
    echo "Error: --since is required (e.g., --since '2026-01-01', --since '3 days ago')"
    usage
fi

# Build date range args for git log
DATE_ARGS="--since=$SINCE"
if [[ -n "$UNTIL" ]]; then
    DATE_ARGS="$DATE_ARGS --until=$UNTIL"
fi

# Generate changelog
generate() {
    local title
    if [[ -n "$UNTIL" ]]; then
        title="# Changelog: $SINCE → $UNTIL"
    else
        title="# Changelog since $SINCE"
    fi

    echo "$title"
    echo

    # Fetch commits grouped by date
    git log "$BRANCH" $DATE_ARGS \
        --format="%ad|%s" \
        --date=short \
        --no-merges \
        --reverse | \
    awk -F'|' '
    {
        date = $1
        msg = $2
        if (date != prev_date) {
            if (prev_date != "") print ""
            print "## " date
            prev_date = date
        }
        print "- " msg
    }'
}

if [[ -n "$OUTPUT" ]]; then
    generate > "$OUTPUT"
    echo "Changelog written to $OUTPUT"
else
    generate
fi
