#!/usr/bin/env python3
"""Install original CC0 art from Kenney's Simplified Platformer Pack."""
from io import BytesIO
from pathlib import Path
from urllib.request import Request, urlopen
from zipfile import ZipFile

ROOT = Path(__file__).resolve().parent
DESTINATION = ROOT / "assets" / "kenney"
FILES = ("platformChar_idle.png", "platformChar_walk1.png", "platformChar_walk2.png")
SOURCES = (
    "https://kenney.nl/media/pages/assets/simplified-platformer-pack/2d06327041-1677693200/kenney_simplified-platformer-pack.zip",
    "https://opengameart.org/sites/default/files/kenney_simplifiedPlatformer.zip",
)


def download_pack():
    for source in SOURCES:
        try:
            request = Request(source, headers={"User-Agent": "Mozilla/5.0"})
            with urlopen(request, timeout=30) as response:
                content = response.read()
            return ZipFile(BytesIO(content))
        except Exception as error:
            print(f"Could not download from {source}: {error}")
    raise SystemExit("Could not download Kenney CC0 art. See ASSET_SOURCE.md for the source links.")


def main():
    if all((DESTINATION / name).exists() for name in FILES):
        print("Kenney assets are already installed.")
        return

    with download_pack() as archive:
        names = archive.namelist()
        for name in FILES:
            # The archive contains several formats; select the 96x96 PNG frames.
            choices = [p for p in names if p.endswith("/" + name) or p == name]
            choices.sort(key=lambda p: ("double" in p.lower(), "retina" in p.lower(), len(p)))
            if not choices:
                raise SystemExit(f"Missing {name} in Kenney archive; layout may have changed.")
            DESTINATION.mkdir(parents=True, exist_ok=True)
            (DESTINATION / name).write_bytes(archive.read(choices[0]))
            print(f"Installed {name} from {choices[0]}")

    print("Done. Open game.project in Defold.")


if __name__ == "__main__":
    main()
