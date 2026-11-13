import tempfile
import unittest
from pathlib import Path
from unittest.mock import patch

import build_examples


class BundleExportTests(unittest.TestCase):
	def test_exports_bundle_from_successful_build(self):
		with tempfile.TemporaryDirectory() as tmp:
			root = Path(tmp)
			project = root / "sprite" / "example"
			project.mkdir(parents=True)
			(project / "game.project").write_text("title = Example\n")
			output = root / "output"

			def fake_build(*args, cwd, **kwargs):
				bundle = cwd / "build" / "default" / "Example"
				bundle.mkdir(parents=True)
				(bundle / "index.html").write_text("index")
				(bundle / "game.arcd").write_text("bundle")

			with patch.object(build_examples.subprocess, "run", side_effect=fake_build):
				# The exported layout uses project paths relative to the repository root.
				with patch.object(build_examples, "prepare_project_copy") as prepare:
					copy = root / "temporary" / "example"
					copy.mkdir(parents=True)
					prepare.return_value = copy
					build_examples.build_project("bob.jar", Path("sprite/example"), output)
			self.assertEqual((output / "sprite/example/game.arcd").read_text(), "bundle")

	def test_missing_bundle_fails(self):
		with tempfile.TemporaryDirectory() as tmp:
			copy = Path(tmp) / "temporary" / "example"
			copy.mkdir(parents=True)
			with patch.object(build_examples, "prepare_project_copy", return_value=copy), patch.object(build_examples.subprocess, "run"):
				with self.assertRaises(RuntimeError):
					build_examples.build_project("bob.jar", Path("sprite/example"), Path(tmp) / "output")


if __name__ == "__main__":
	unittest.main()
