#!/usr/bin/env python3

from __future__ import annotations

import argparse
import json
import shutil
import subprocess
import sys
import tempfile
from pathlib import Path


BUILD_SERVER_URL = "https://build-stage.defold.com/"


def tracked_example_projects() -> list[Path]:
	try:
		output = subprocess.check_output(
			["git", "ls-files", "*/game.project"],
			text=True,
			stderr=subprocess.DEVNULL,
		)
		projects = [Path(line).parent for line in output.splitlines() if line.strip()]
		if projects:
			return sorted(set(projects))
	except (FileNotFoundError, subprocess.CalledProcessError):
		pass

	return sorted(path.parent for path in Path(".").glob("*/*/game.project"))


def touched_example_projects(base_ref: str, head_ref: str) -> list[Path]:
	if not base_ref or base_ref == "0000000000000000000000000000000000000000":
		return tracked_example_projects()

	output = subprocess.check_output(
		["git", "diff", "--name-status", "--find-renames", base_ref, head_ref],
		text=True,
		stderr=subprocess.DEVNULL,
	)
	projects: set[Path] = set()

	for line in output.splitlines():
		parts = line.split("\t")
		for candidate in parts[1:]:
			if not candidate:
				continue

			path = Path(candidate)
			if len(path.parts) < 2:
				continue

			projects.add(Path(path.parts[0]) / path.parts[1])

	return sorted(projects)


def normalize_ref(value: str) -> str:
	return value.strip().strip("\"'")


def parse_args() -> argparse.Namespace:
	parser = argparse.ArgumentParser()
	parser.add_argument("--bob-jar", default="bob.jar")
	parser.add_argument("--changed-from", default="")
	parser.add_argument("--changed-to", default="")
	parser.add_argument("--dry-run", action="store_true")
	parser.add_argument("--list-json", action="store_true")
	return parser.parse_args()


def prepare_project_copy(project_dir: Path) -> Path:
	temp_dir = Path(tempfile.mkdtemp(prefix="defold-example-build-"))
	project_copy = temp_dir / project_dir.name
	shutil.copytree(project_dir, project_copy)

	game_project = project_copy / "game.project"
	lines = game_project.read_text(encoding="utf-8").splitlines()
	updated_lines = []
	replaced = False
	for line in lines:
		if line.startswith("title = "):
			updated_lines.append("title = Defold-examples")
			replaced = True
		else:
			updated_lines.append(line)
	if not replaced:
		updated_lines.append("title = Defold-examples")
	game_project.write_text("\n".join(updated_lines) + "\n", encoding="utf-8")

	return project_copy


def build_project(bob_jar: str, project_dir: Path) -> None:
	print(f"Building {project_dir}")
	bob_jar_path = Path(bob_jar).resolve()
	project_copy = prepare_project_copy(project_dir)
	try:
		subprocess.run(
			[
				"java",
				"-jar",
				str(bob_jar_path),
				"--archive",
				"--platform",
				"wasm-web",
				"--architectures",
				"wasm-web",
				"--variant",
				"debug",
				"--build-server",
				BUILD_SERVER_URL,
				"resolve",
				"build",
				"bundle",
			],
			check=True,
			cwd=project_copy,
		)
	finally:
		shutil.rmtree(project_copy.parent)


def main() -> int:
	args = parse_args()

	changed_from = normalize_ref(args.changed_from)
	changed_to = normalize_ref(args.changed_to)

	if changed_from and changed_to:
		projects = touched_example_projects(changed_from, changed_to)
	else:
		projects = tracked_example_projects()

	if args.dry_run:
		print(len(projects))
		return 0

	if args.list_json:
		print(json.dumps([str(project) for project in projects]))
		return 0

	for project_dir in projects:
		if (project_dir / "game.project").is_file():
			build_project(args.bob_jar, project_dir)

	print("Example builds passed.")
	return 0


if __name__ == "__main__":
	sys.exit(main())
