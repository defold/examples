#!/usr/bin/env python3

from __future__ import annotations

import os
import subprocess
import sys
from pathlib import Path


SCRIPT_EXTENSIONS = {
	".script",
	".gui_script",
	".lua",
	".vp",
	".fp",
	".cp",
	".glsl",
	".render_script",
}


def tracked_example_docs() -> list[Path]:
	try:
		output = subprocess.check_output(
			["git", "ls-files", "*/example.md"],
			text=True,
			stderr=subprocess.DEVNULL,
		)
		files = [Path(line) for line in output.splitlines() if line.strip()]
		if files:
			return files
	except (FileNotFoundError, subprocess.CalledProcessError):
		pass

	return sorted(Path(".").glob("*/*/example.md"))


def frontmatter_value(markdown_file: Path, key: str) -> str | None:
	lines = markdown_file.read_text(encoding="utf-8").splitlines()
	if not lines or lines[0] != "---":
		return None

	for line in lines[1:]:
		if line == "---":
			return None
		if not line.startswith(f"{key}:"):
			continue
		return line.split(":", 1)[1].strip()

	return None


def split_scripts(value: str | None) -> list[str]:
	if not value:
		return []

	if value.startswith("[") and value.endswith("]"):
		value = value[1:-1]

	return [script.strip().strip("\"'") for script in value.split(",") if script.strip()]


def example_scripts(example_dir: Path) -> set[str]:
	scripts: set[str] = set()
	source_dir = example_dir / "example"
	if not source_dir.exists():
		return scripts

	for path in source_dir.rglob("*"):
		if path.is_file() and path.suffix in SCRIPT_EXTENSIONS:
			scripts.add(path.name)

	return scripts


def validate() -> int:
	errors: list[str] = []

	for markdown_file in tracked_example_docs():
		example_dir = markdown_file.parent
		available_scripts = example_scripts(example_dir)

		for script in split_scripts(frontmatter_value(markdown_file, "scripts")):
			if script != os.path.basename(script):
				errors.append(f"{markdown_file}: scripts entry must be a file name, got '{script}'")
			elif script not in available_scripts:
				errors.append(f"{markdown_file}: scripts entry '{script}' does not exist in {example_dir / 'example'}")

	if errors:
		print("Example validation failed:")
		for error in errors:
			print(f"- {error}")
		return 1

	print("Example validation passed.")
	return 0


if __name__ == "__main__":
	sys.exit(validate())
