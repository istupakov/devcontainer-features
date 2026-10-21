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

Dev Containers installs `openai.chatgpt` when VS Code attaches to the container.
The Feature does not install a standalone Codex CLI or require Node.js.

See the [Codex IDE documentation](https://learn.chatgpt.com/docs/codex/ide) and
[Codex state directory documentation](https://learn.chatgpt.com/docs/config-file/config-advanced).
