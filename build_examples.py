#!/usr/bin/env python3

from __future__ import annotations

import argparse
import subprocess
import sys
from pathlib import Path


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

			project_dir = Path(path.parts[0]) / path.parts[1]
			projects.add(project_dir)

	return sorted(projects)


def parse_args() -> argparse.Namespace:
	parser = argparse.ArgumentParser()
	parser.add_argument("--bob-jar", default="bob.jar")
	parser.add_argument("--changed-from", default="")
	parser.add_argument("--changed-to", default="")
	parser.add_argument("--dry-run", action="store_true")
	return parser.parse_args()


def build_project(bob_jar: str, project_dir: Path) -> None:
	print(f"Building {project_dir}")
	subprocess.run(
		["java", "-jar", bob_jar, "--root", str(project_dir), "distclean", "build"],
		check=True,
	)


def main() -> int:
	args = parse_args()

	if args.changed_from and args.changed_to:
		projects = touched_example_projects(args.changed_from, args.changed_to)
	else:
		projects = tracked_example_projects()

	if args.dry_run:
		print(len(projects))
		return 0

	for project_dir in projects:
		if (project_dir / "game.project").is_file():
			build_project(args.bob_jar, project_dir)

	print("Example builds passed.")
	return 0


if __name__ == "__main__":
	sys.exit(main())
