import tempfile
import unittest
from pathlib import Path

from validate_examples import example_scripts, resolve_script_reference


class ExampleScriptResolutionTests(unittest.TestCase):
	def setUp(self):
		self.temp_dir = tempfile.TemporaryDirectory()
		self.project_dir = Path(self.temp_dir.name)

	def tearDown(self):
		self.temp_dir.cleanup()

	def add_script(self, relative_path: str) -> None:
		path = self.project_dir / relative_path
		path.parent.mkdir(parents=True, exist_ok=True)
		path.write_text("function init(self) end\n", encoding="utf-8")

	def test_unique_filename_is_found_anywhere_in_project(self):
		self.add_script("main/scroll_manager/scroll_item.script")
		available = example_scripts(self.project_dir)

		self.assertEqual(
			resolve_script_reference("scroll_item.script", available),
			"main/scroll_manager/scroll_item.script",
		)

	def test_exact_project_relative_path_is_supported(self):
		self.add_script("main/scroll_manager/scroll_item.script")
		available = example_scripts(self.project_dir)

		self.assertEqual(
			resolve_script_reference("main/scroll_manager/scroll_item.script", available),
			"main/scroll_manager/scroll_item.script",
		)
		with self.assertRaisesRegex(ValueError, "does not exist"):
			resolve_script_reference("scroll_manager/scroll_item.script", available)

	def test_ambiguous_filename_lists_exact_paths(self):
		self.add_script("main/first/controller.script")
		self.add_script("main/second/controller.script")
		available = example_scripts(self.project_dir)

		with self.assertRaisesRegex(
			ValueError,
			"main/first/controller.script, main/second/controller.script",
		):
			resolve_script_reference("controller.script", available)
		self.assertEqual(
			resolve_script_reference("main/second/controller.script", available),
			"main/second/controller.script",
		)

	def test_generated_and_dependency_directories_are_ignored(self):
		self.add_script("main/controller.script")
		self.add_script("build/controller.script")
		self.add_script(".internal/lib/controller.script")
		self.add_script("node_modules/package/controller.script")

		self.assertEqual(example_scripts(self.project_dir), ["main/controller.script"])

	def test_unsafe_or_non_normalized_paths_are_rejected(self):
		for script in (
			"/main/controller.script",
			"./main/controller.script",
			"main/../controller.script",
			"main\\controller.script",
		):
			with self.subTest(script=script), self.assertRaisesRegex(ValueError, "normalized"):
				resolve_script_reference(script, [])


if __name__ == "__main__":
	unittest.main()
