"""Run with: python3 -m unittest discover -s tests"""

import os
from pathlib import Path
import stat
import subprocess
import tempfile
import unittest


ROOT = Path(__file__).resolve().parents[1]


class NightscoutSetupTests(unittest.TestCase):
    def setUp(self):
        self.home = tempfile.TemporaryDirectory(prefix="nightscout-test-")
        self.addCleanup(self.home.cleanup)
        self.key_file = Path(self.home.name) / ".config/myhomemaker/nightscout-api-key"
        # Load function definitions only; never execute the machine-wide setup.
        self.functions = (ROOT / "configure.sh").read_text().split(
            "\ndisplayAsciiDisclaimer\n"
        )[0]

    def configure(self, value, system="Darwin"):
        return subprocess.run(
            ["bash", "-c", self.functions + f"\nuname() {{ echo {system}; }}\nconfigNightscout\n"],
            input=value,
            text=True,
            capture_output=True,
            env=dict(os.environ, HOME=self.home.name),
            check=True,
        )

    def test_secret_is_private_and_not_printed(self):
        result = self.configure("test-secret\n")
        self.assertEqual(self.key_file.read_text(), "test-secret")
        self.assertEqual(stat.S_IMODE(self.key_file.stat().st_mode), 0o600)
        self.assertEqual(stat.S_IMODE(self.key_file.parent.stat().st_mode), 0o700)
        self.assertNotIn("test-secret", result.stdout + result.stderr)

    def test_blank_input_preserves_existing_secret(self):
        self.configure("test-secret\n")
        self.configure("\n")
        self.assertEqual(self.key_file.read_text(), "test-secret")

    def test_linux_setup_does_not_create_credentials(self):
        self.configure("", system="Linux")
        self.assertFalse(self.key_file.exists())

    def test_linux_migration_is_a_no_op(self):
        script = (ROOT / "scripts/prepare-nightscout.sh").read_text()
        subprocess.run(
            ["bash", "-c", script + "\nuname() { echo Linux; }\nprepareNightscoutApp\n"],
            capture_output=True,
            check=True,
            env=dict(os.environ, HOME=self.home.name),
        )
        self.assertFalse((Path(self.home.name) / "Applications").exists())


if __name__ == "__main__":
    unittest.main()
