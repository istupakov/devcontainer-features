"""Offline extension installation tests using a synthetic VS Code CLI."""

import os
from pathlib import Path
import subprocess
import tempfile
import unittest

HOOK = Path(__file__).resolve().parents[1] / "src/codex/install-extension.sh"


class ExtensionInstallationTests(unittest.TestCase):
    def run_hook(self, enabled, cli="code", exit_code=0):
        with tempfile.TemporaryDirectory(prefix="codex-extension-test.") as tmp:
            root = Path(tmp)
            script = root / "attach.sh"
            template = HOOK.read_text()
            script.write_text(template.replace("@INSTALL_EXTENSION@", enabled))
            invocation = root / "invocation"
            if cli:
                mock = root / cli
                mock.write_text('#!/bin/sh\nprintf "%s\\n" "$@" > "$INVOCATION"\n'
                                f'exit {exit_code}\n')
                mock.chmod(0o755)
            env = dict(os.environ, PATH=str(root), INVOCATION=str(invocation))
            result = subprocess.run(["/bin/sh", str(script)], env=env,
                                    capture_output=True, text=True)
            args = invocation.read_text().splitlines() if invocation.exists() else None
            return result, args

    def test_enabled_installs_with_stable_and_insiders_cli(self):
        for cli in ("code", "code-insiders"):
            with self.subTest(cli=cli):
                result, args = self.run_hook("true", cli)
                self.assertEqual(result.returncode, 0, result.stderr)
                self.assertEqual(args, ["--install-extension", "openai.chatgpt"])

    def test_disabled_does_not_invoke_cli(self):
        result, args = self.run_hook("false")
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIsNone(args)

    def test_missing_cli_skips_with_message(self):
        result, args = self.run_hook("true", cli=None)
        self.assertEqual(result.returncode, 0, result.stderr)
        self.assertIsNone(args)
        self.assertIn("CLI is not available", result.stderr)

    def test_installation_failure_is_reported(self):
        result, _ = self.run_hook("true", exit_code=42)
        self.assertEqual(result.returncode, 42)


if __name__ == "__main__":
    unittest.main()
