#!/bin/bash
set -euo pipefail

repo_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
fixture_home="$(mktemp -d "${TMPDIR:-/tmp}/codex-feature-test.XXXXXXXX")"
trap 'rm -rf -- "$fixture_home"' EXIT

# Keep Docker contexts/credentials available while isolating Codex state.
export DOCKER_CONFIG="${DOCKER_CONFIG:-$HOME/.docker}"
mkdir "$fixture_home/.codex"
printf '%s\n' codex-feature-test > "$fixture_home/.codex/fixture-marker"
printf '%s\n' codex-host-fixture > "$fixture_home/.codex/host-username"
# Test users can have different UIDs. These permissions apply only to the fixture.
chmod 755 "$fixture_home"
chmod 777 "$fixture_home/.codex"

HOME="$fixture_home" devcontainer features test --features codex "$@" "$repo_dir"

shopt -s nullglob
writes=("$fixture_home"/.codex/write-*)
if (( ${#writes[@]} == 0 )); then
    echo "No container write reached the host fixture." >&2
    exit 1
fi
for marker in "${writes[@]}"; do
    test "$(cat "$marker")" = "${marker##*/write-}"
done
echo "Verified container writes on the host fixture."
