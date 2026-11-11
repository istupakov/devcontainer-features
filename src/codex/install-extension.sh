#!/bin/sh
set -eu

# install.sh substitutes the Feature option at build time. Run as the remote
# user at attach time, when the VS Code remote CLI is available.
[ "@INSTALL_EXTENSION@" = "true" ] || exit 0

for cli in code code-insiders; do
    if command -v "$cli" >/dev/null 2>&1; then
        exec "$cli" --install-extension openai.chatgpt
    fi
done

echo "Skipping Codex extension installation: VS Code CLI is not available." >&2
