#!/usr/bin/env bash
: "${ROOT_DIR:=$(pwd)}"
if [[ -f "common.sh" ]]; then
    source common.sh
elif [[ -d tests ]]; then
    source tests/common.sh
else
    echo "Can't find common.sh!" >&2
    exit 1
fi

version_file="$ROOT_DIR/VERSION.txt"
[[ -f "$version_file" ]] || error "Can't find $version_file"

current=$(tr -d '[:space:]' < "$version_file")

semver_format='^[0-9]+\.[0-9]+\.[0-9]+$'
[[ "$current" =~ $semver_format ]] \
  || error "VERSION '$current' is not plain semver (X.Y.Z)"

# Env variable from workflow
[[ -n "${LATEST_RELEASE:-}" ]] || error "LATEST_RELEASE is not set"

highest=$(printf '%s\n%s\n' "$LATEST_RELEASE" "$current" | sort -V | tail -n1)

if [[ "$current" == "$LATEST_RELEASE" || "$highest" != "$current" ]]; then
  error "Version $current must be higher than latest release $LATEST_VERSION"
fi

success "Version $current > latest release $LATEST_VERSION"