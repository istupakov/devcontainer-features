#!/bin/bash
set -euo pipefail
test "$(id -un)" = node
bash "$(dirname "$0")/test.sh"
