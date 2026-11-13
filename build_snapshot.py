#!/usr/bin/env python3
"""Create a complete, reusable snapshot of successfully built examples."""
import argparse
import hashlib
import json
import shutil
import subprocess
import sys
import tempfile
import zipfile
from pathlib import Path

from build_examples import build_project, touched_example_projects, tracked_example_projects


def build_snapshot(bob, output, baseline=None, full=False, keep_going=False):
    head = subprocess.check_output(['git', 'rev-parse', 'HEAD'], text=True).strip()
    projects = set(tracked_example_projects())
    build_config = hashlib.sha256(Path('build_examples.py').read_bytes()).hexdigest()
    with tempfile.TemporaryDirectory(prefix='example-snapshot-') as temp:
        root = Path(temp)
        bundles = root / 'bundles'
        bundles.mkdir()
        base_sha = None
        if baseline and not full:
            with zipfile.ZipFile(baseline) as archive:
                # Only snapshots produced by this workflow are accepted.
                for entry in archive.infolist():
                    path = Path(entry.filename)
                    if path.is_absolute() or '..' in path.parts:
                        raise ValueError('Invalid snapshot path')
                archive.extractall(root)
            manifest = json.loads((root / 'manifest.json').read_text())
            base_sha = manifest['examples_sha']
            if subprocess.run(['git', 'merge-base', '--is-ancestor', base_sha, head]).returncode != 0:
                raise RuntimeError('Snapshot revision is not an ancestor of HEAD')
            if manifest.get('build_config') != build_config:
                base_sha = None

        changed = set(touched_example_projects(base_sha, head)) if base_sha else set(projects)
        for category in bundles.iterdir():
            if category.is_dir():
                for example in category.iterdir():
                    if Path(category.name, example.name) not in projects:
                        shutil.rmtree(example)
        failed = []
        for project in sorted(projects):
            if project in changed or not (bundles / project / 'index.html').is_file():
                try:
                    build_project(bob, project, bundles)
                except (subprocess.CalledProcessError, RuntimeError):
                    if not keep_going:
                        raise
                    failed.append(project)
        if failed:
            print('Failed example builds:', file=sys.stderr)
            for project in failed:
                print(f'  {project}', file=sys.stderr)
            raise RuntimeError(f'{len(failed)} example builds failed; snapshot not published')
        (root / 'manifest.json').write_text(json.dumps({'examples_sha': head, 'build_config': build_config}, sort_keys=True) + '\n')
        output = Path(output).resolve()
        with zipfile.ZipFile(output, 'w', compression=zipfile.ZIP_DEFLATED, compresslevel=6) as archive:
            for file in sorted(root.rglob('*')):
                if file.is_file():
                    archive.write(file, file.relative_to(root))


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--bob-jar', default='bob.jar')
    parser.add_argument('--output', default='examples-bundles.zip')
    parser.add_argument('--baseline')
    parser.add_argument('--full', action='store_true')
    parser.add_argument('--keep-going', action='store_true')
    args = parser.parse_args()
    build_snapshot(args.bob_jar, args.output, args.baseline, args.full, args.keep_going)
