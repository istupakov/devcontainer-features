#!/bin/sh
set -eu

install_extension=${INSTALLEXTENSION:-false}
case "$install_extension" in
    true|false) ;;
    *) echo "installExtension must be true or false" >&2; exit 1 ;;
esac

sed "s/@INSTALL_EXTENSION@/$install_extension/g" "$(dirname "$0")/install-extension.sh" \
    > /usr/local/bin/codex-devcontainer-install-extension
chmod 0755 /usr/local/bin/codex-devcontainer-install-extension
