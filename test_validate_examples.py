import tempfile
import unittest
from unittest import mock
import argparse
import contextlib
import io
from pathlib import Path

from validate_examples import example_scripts, resolve_script_reference, validate_author_ids
from validate_examples import validate


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

	def test_rejects_project_without_example_documentation(self):
		(self.project_dir / "game.project").write_text("[project]\n", encoding="utf-8")
		output = io.StringIO()
		with mock.patch("validate_examples.parse_args", return_value=argparse.Namespace(changed_from="", changed_to="")), mock.patch("validate_examples.tracked_example_dirs", return_value=[self.project_dir]), contextlib.redirect_stdout(output):
			self.assertEqual(1, validate())
		self.assertIn("missing required example documentation", output.getvalue())

	def test_ignores_removed_example_directory(self):
		with mock.patch("validate_examples.parse_args", return_value=argparse.Namespace(changed_from="before", changed_to="after")), mock.patch("validate_examples.touched_example_dirs", return_value=[self.project_dir / "removed"]), contextlib.redirect_stdout(io.StringIO()):
			self.assertEqual(0, validate())

	def write_frontmatter(self, content: str) -> Path:
		path = self.project_dir / "example.md"
		path.write_text(f"---\n{content}\n---\n", encoding="utf-8")
		return path

	def test_accepts_one_or_more_stable_author_ids(self):
		markdown = self.write_frontmatter(
			"author_ids:\n  - defold-foundation\n  - another-contributor"
		)
		self.assertEqual([], validate_author_ids(markdown))

	def test_accepts_legacy_author_as_one_author(self):
		for author in ("author: alice", "author: Evgenii Starostin"):
			with self.subTest(author=author):
				self.assertEqual(
					[], validate_author_ids(self.write_frontmatter(author))
				)

	def test_rejects_missing_malformed_and_duplicate_author_ids(self):
		cases = (
			("title: Missing", "at least one"),
			("author:", "at least one"),
			('author: ""', "at least one"),
			("author_ids:\n  - Defold Foundation", "kebab-case"),
			("author_ids:\n  - alice\n  - alice", "duplicates"),
		)
		for frontmatter, message in cases:
			with self.subTest(frontmatter=frontmatter):
				errors = validate_author_ids(self.write_frontmatter(frontmatter))
				self.assertTrue(any(message in error for error in errors), errors)

	def test_rejects_legacy_authors_field(self):
		markdown = self.write_frontmatter("authors:\n  - Alice\nauthor_ids:\n  - alice")
		self.assertTrue(
			any("legacy" in error for error in validate_author_ids(markdown))
		)

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
