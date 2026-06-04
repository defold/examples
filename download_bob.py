#!/usr/bin/env python3

from __future__ import annotations

import argparse
import json
import urllib.request
from pathlib import Path


GITHUB_RELEASES_URL = "https://api.github.com/repos/defold/defold/releases?per_page=100"


def parse_args() -> argparse.Namespace:
	parser = argparse.ArgumentParser()
	parser.add_argument("--channel", default="beta")
	parser.add_argument("--output", default="bob.jar")
	return parser.parse_args()


def fetch_releases() -> list[dict[str, object]]:
	request = urllib.request.Request(
		GITHUB_RELEASES_URL,
		headers={"User-Agent": "codex-defold-examples"},
	)
	with urllib.request.urlopen(request) as response:
		return json.loads(response.read().decode("utf-8"))


def find_release(releases: list[dict[str, object]], channel: str) -> dict[str, object]:
	channel = channel.lower()
	for release in releases:
		name = str(release.get("name", "")).lower()
		tag_name = str(release.get("tag_name", "")).lower()
		if release.get("prerelease") and (channel in name or channel in tag_name):
			return release

	raise SystemExit(f"Could not find a {channel} release for defold/defold.")


def find_bob_asset(release: dict[str, object]) -> dict[str, object]:
	for asset in release.get("assets", []):
		if isinstance(asset, dict) and asset.get("name") == "bob.jar":
			return asset

	raise SystemExit("Could not find bob.jar in the selected Defold release.")


def download_asset(url: str, output: Path) -> None:
	request = urllib.request.Request(
		url,
		headers={"User-Agent": "codex-defold-examples"},
	)
	with urllib.request.urlopen(request) as response:
		output.write_bytes(response.read())


def main() -> int:
	args = parse_args()
	release = find_release(fetch_releases(), args.channel)
	asset = find_bob_asset(release)
	download_asset(str(asset["browser_download_url"]), Path(args.output))
	print(args.output)
	return 0


if __name__ == "__main__":
	raise SystemExit(main())
