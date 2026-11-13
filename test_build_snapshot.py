import json
import tempfile
import unittest
import zipfile
from pathlib import Path
from unittest.mock import patch

import build_snapshot


class SnapshotTests(unittest.TestCase):
    def test_full_build_reports_failures_without_writing_snapshot(self):
        with tempfile.TemporaryDirectory() as temp:
            output = Path(temp) / 'snapshot.zip'
            built = []

            def build(bob, project, destination):
                built.append(project)
                if project == Path('sprite/a'):
                    raise RuntimeError('failed')

            with patch.object(build_snapshot, 'tracked_example_projects', return_value={Path('sprite/a'), Path('sprite/b')}), \
                 patch.object(build_snapshot.subprocess, 'check_output', return_value='abc\n'), \
                 patch.object(build_snapshot, 'build_project', side_effect=build):
                with self.assertRaises(RuntimeError):
                    build_snapshot.build_snapshot('bob.jar', output, full=True, keep_going=True)
            self.assertEqual(built, [Path('sprite/a'), Path('sprite/b')])
            self.assertFalse(output.exists())

    def test_reuses_unchanged_bundles_and_preserves_previous_on_failure(self):
        with tempfile.TemporaryDirectory() as temp:
            root = Path(temp)
            first, second = root / 'first.zip', root / 'second.zip'
            projects = {Path('sprite/a'), Path('sprite/b')}
            built = []

            def build(bob, project, destination):
                built.append(project)
                bundle = destination / project
                bundle.mkdir(parents=True, exist_ok=True)
                (bundle / 'index.html').write_text(str(project))

            with patch.object(build_snapshot, 'tracked_example_projects', return_value=projects), \
                 patch.object(build_snapshot.subprocess, 'check_output', return_value='abc\n'), \
                 patch.object(build_snapshot, 'build_project', side_effect=build):
                build_snapshot.build_snapshot('bob.jar', first)
            self.assertEqual(set(built), projects)
            built.clear()
            with patch.object(build_snapshot, 'tracked_example_projects', return_value=projects), \
                 patch.object(build_snapshot.subprocess, 'check_output', return_value='def\n'), \
                 patch.object(build_snapshot.subprocess, 'run') as ancestry, \
                 patch.object(build_snapshot, 'touched_example_projects', return_value=[Path('sprite/a')]), \
                 patch.object(build_snapshot, 'build_project', side_effect=build):
                ancestry.return_value.returncode = 0
                build_snapshot.build_snapshot('bob.jar', second, first)
            self.assertEqual(built, [Path('sprite/a')])
            with zipfile.ZipFile(second) as archive:
                self.assertEqual(archive.read('bundles/sprite/b/index.html'), b'sprite/b')
                self.assertEqual(json.loads(archive.read('manifest.json'))['examples_sha'], 'def')
            original = first.read_bytes()
            with patch.object(build_snapshot, 'tracked_example_projects', return_value=projects), \
                 patch.object(build_snapshot.subprocess, 'check_output', return_value='def\n'), \
                 patch.object(build_snapshot, 'build_project', side_effect=RuntimeError('failed')):
                with self.assertRaises(RuntimeError):
                    build_snapshot.build_snapshot('bob.jar', second, full=True)
            self.assertEqual(first.read_bytes(), original)


if __name__ == '__main__':
    unittest.main()
