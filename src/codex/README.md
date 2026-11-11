
# Codex (codex)

Share host Codex configuration and state, with optional VS Code extension installation.

## Example Usage

```json
"features": {
    "ghcr.io/istupakov/devcontainer-features/codex:2": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| installExtension | Install the Codex VS Code extension when VS Code attaches. Disabled by default for Agent Host. | boolean | false |

## Host setup

Create the host directory before starting the container:

```sh
mkdir -p "$HOME/.codex"
```

The Feature bind-mounts `${localEnv:HOME}/.codex` at `/codex` with read/write
access and sets `CODEX_HOME=/codex`. The path works with any container username
or home directory, including `root`, `vscode`, and `node`.

On Linux, the container user must have permission to read and write the host
files. Align the user's UID/GID with the host as needed (Dev Containers normally
updates the remote user's UID/GID). This Feature does not change ownership or
permissions. A fixed path does not bypass filesystem permissions.

The host and container share configuration, authentication files, and session
state. Container writes affect the host directory. Absolute paths in your host
configuration may need adjustment for the container.

This Feature targets local Dev Containers on Linux/WSL, where `HOME` is set and
the Docker daemon can access that directory. Remote Docker hosts and Codespaces
are not supported by this host bind-mount setup.

## VS Code extension

The extension is not installed by default. The Feature does not install a
standalone Codex CLI or require Node.js.

### Choose whether to install the VS Code extension

Set `installExtension` to `true` to install `openai.chatgpt` on attachment.
This works in VS Code user settings with
`dev.containers.defaultFeatures`:

```json
{
    "dev.containers.defaultFeatures": {
        "ghcr.io/istupakov/devcontainer-features/codex:2": {
            "installExtension": true
        }
    }
}
```

The same option works in a project's `devcontainer.json`:

```json
{
    "features": {
        "ghcr.io/istupakov/devcontainer-features/codex:2": {
            "installExtension": true
        }
    }
}
```

Rebuild the container after changing the option. Omit it or set it to `false`
to skip extension installation. Setting it to `false` does not uninstall an existing
extension or prevent installation requested by other VS Code settings.
Host Codex configuration, authentication files, and session state remain shared
with either choice.

Installation runs as the remote user in `postAttachCommand`, using `code` or
`code-insiders`. Without either CLI, the hook reports that installation was
skipped. Installation failures from an available CLI are reported as hook
failures and retried on the next attachment.

See the [Codex IDE documentation](https://learn.chatgpt.com/docs/codex/ide) and
[Codex state directory documentation](https://learn.chatgpt.com/docs/config-file/config-advanced).

## Upgrade from version 1

Change the Feature reference from `:1` to `:2` and rebuild the container.
Version 2 disables automatic extension installation by default. Set
`installExtension` to `true` to keep installing the extension. The host directory
mount and shared Codex state are unchanged.


---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/istupakov/devcontainer-features/blob/main/src/codex/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
