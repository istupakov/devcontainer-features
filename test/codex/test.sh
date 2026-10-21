#!/bin/bash
set -euo pipefail

# Only the synthetic fixture created by test/run.sh is accepted.
test "${CODEX_HOME:-}" = /codex
test "$(cat /codex/fixture-marker)" = codex-feature-test
test "$(cat /codex/host-username)" != "$(id -un)"
awk '$5 == "/codex" { found = 1 } END { exit !found }' /proc/self/mountinfo
printf '%s\n' "$(id -un)" > "/codex/write-$(id -un)"
echo "Codex mount read/write checks passed for $(id -un)."
