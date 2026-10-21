#!/bin/bash
set -euo pipefail
test "$(id -un)" = vscode
bash "$(dirname "$0")/test.sh"
