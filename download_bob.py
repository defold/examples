#!/usr/bin/env python3

from __future__ import annotations

import argparse
import json
import urllib.request
from pathlib import Path


INFO_URL_TEMPLATE = "https://d.defold.com/{channel}/info.json"
BOB_URL_TEMPLATE = "https://d.defold.com/archive/{sha1}/bob/bob.jar"


def parse_args() -> argparse.Namespace:
	parser = argparse.ArgumentParser()
	parser.add_argument("--channel", default="beta")
	parser.add_argument("--output", default="bob.jar")
	return parser.parse_args()


def fetch_json(url: str) -> dict[str, object]:
	request = urllib.request.Request(
		url,
		headers={"User-Agent": "codex-defold-examples"},
	)
	with urllib.request.urlopen(request) as response:
		return json.loads(response.read().decode("utf-8"))


def fetch_sha1(channel: str) -> str:
	info = fetch_json(INFO_URL_TEMPLATE.format(channel=channel))
	sha1 = str(info.get("sha1", "")).strip()
	if not sha1:
		raise SystemExit(f"Could not find sha1 for Defold channel '{channel}'.")
	return sha1


def download_asset(url: str, output: Path) -> None:
	request = urllib.request.Request(
		url,
		headers={"User-Agent": "codex-defold-examples"},
	)
	with urllib.request.urlopen(request) as response:
		output.write_bytes(response.read())


def main() -> int:
	args = parse_args()
	sha1 = fetch_sha1(args.channel)
	download_asset(BOB_URL_TEMPLATE.format(sha1=sha1), Path(args.output))
	print(args.output)
	return 0


if __name__ == "__main__":
	raise SystemExit(main())
