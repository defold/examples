#!/usr/bin/env python3

from __future__ import annotations

import argparse
import os
import subprocess
import sys
from pathlib import Path, PurePosixPath


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

IGNORED_SCRIPT_DIRS = {
	".deps",
	".git",
	".internal",
	"build",
	"builtins",
	"js-web",
	"node_modules",
}


def tracked_example_dirs() -> list[Path]:
	try:
		output = subprocess.check_output(
			["git", "ls-files", "*/game.project"],
			text=True,
			stderr=subprocess.DEVNULL,
		)
		directories = [Path(line).parent for line in output.splitlines() if line.strip()]
		if directories:
			return sorted(set(directories))
	except (FileNotFoundError, subprocess.CalledProcessError):
		pass

	return sorted(path.parent for path in Path(".").glob("*/*/game.project"))


def touched_example_dirs(base_ref: str, head_ref: str) -> list[Path]:
	if not base_ref or base_ref == "0000000000000000000000000000000000000000":
		return tracked_example_dirs()

	output = subprocess.check_output(
		["git", "diff", "--name-status", "--find-renames", base_ref, head_ref],
		text=True,
		stderr=subprocess.DEVNULL,
	)
	directories: set[Path] = set()

	for line in output.splitlines():
		parts = line.split("\t")
		for candidate in parts[1:]:
			if not candidate:
				continue
			path = Path(candidate)
			if len(path.parts) < 2:
				continue
			directories.add(Path(path.parts[0]) / path.parts[1])

	return sorted(directories)


def normalize_ref(value: str) -> str:
	return value.strip().strip("\"'")


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


def example_scripts(example_dir: Path) -> list[str]:
	scripts: list[str] = []
	if not example_dir.exists():
		return scripts

	for root, dirnames, filenames in os.walk(example_dir):
		dirnames[:] = [dirname for dirname in dirnames if dirname not in IGNORED_SCRIPT_DIRS]
		root_path = Path(root)
		for filename in filenames:
			path = root_path / filename
			if path.suffix in SCRIPT_EXTENSIONS:
				scripts.append(path.relative_to(example_dir).as_posix())

	return sorted(scripts)


def resolve_script_reference(script: str, available_scripts: list[str]) -> str:
	path = PurePosixPath(script)
	if (
		not script
		or "\\" in script
		or path.is_absolute()
		or str(path) != script
		or any(part in {"", ".", ".."} for part in path.parts)
	):
		raise ValueError(
			f"scripts entry must be a file name or normalized project-relative path, got '{script}'"
		)

	if len(path.parts) > 1:
		if script not in available_scripts:
			raise ValueError(f"scripts entry '{script}' does not exist in the project")
		return script

	matches = [candidate for candidate in available_scripts if PurePosixPath(candidate).name == script]
	if not matches:
		raise ValueError(f"scripts entry '{script}' does not exist in the project")
	if len(matches) > 1:
		raise ValueError(
			f"scripts entry '{script}' is ambiguous; use an exact project-relative path: {', '.join(matches)}"
		)
	return matches[0]


def parse_args() -> argparse.Namespace:
	parser = argparse.ArgumentParser()
	parser.add_argument("--changed-from", default="")
	parser.add_argument("--changed-to", default="")
	return parser.parse_args()


def validate() -> int:
	args = parse_args()
	changed_from = normalize_ref(args.changed_from)
	changed_to = normalize_ref(args.changed_to)

	errors: list[str] = []

	example_dirs = (
		touched_example_dirs(changed_from, changed_to)
		if changed_from and changed_to
		else tracked_example_dirs()
	)

	for example_dir in example_dirs:
		markdown_file = example_dir / "example.md"
		if not markdown_file.is_file():
			continue
		available_scripts = example_scripts(example_dir)

		for script in split_scripts(frontmatter_value(markdown_file, "scripts")):
			try:
				resolve_script_reference(script, available_scripts)
			except ValueError as error:
				errors.append(f"{markdown_file}: {error}")

	if errors:
		print("Example validation failed:")
		for error in errors:
			print(f"- {error}")
		return 1

	print("Example validation passed.")
	return 0


if __name__ == "__main__":
	sys.exit(validate())
