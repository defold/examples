# Defold examples

This repository includes the Defold examples used in the examples section on https://defold.com/examples

## CI and website publication

Pull requests build changed examples using the latest Defold beta. Changes to master build the examples changed since the latest successful bundle snapshot and produce a complete snapshot for the website. If there is no usable previous snapshot, all examples are built. A failed build never dispatches a site update. The snapshot is a GitHub Actions artifact retained for 30 days; expired snapshots are automatically removed and the next publication starts with a full build.

The website workflow downloads the snapshot for the dispatched run and imports its matching source revision. It can be retried manually with the `examples` action, which uses the latest successful available snapshot. A separate scheduled workflow builds every example against the latest stable release on the first day of each month without publishing. It can also be run manually.

## Adding more examples
Examples are grouped by category, for instance "physics", "sprite" or "collection". Each group of examples has a folder in /examples. Here's how to add a new example named "foobar" to the "sprite" category:

* Create a folder named `foobar` in `examples/sprite`
* Create `examples/sprite/foobar/game.project` and the files required for your example
* Create `examples/sprite/foobar/example.md` with example documentation. The file must start with:

```
---
title: Foobar
brief: This example shows how to use foobar.
author_ids:
  - defold-foundation
  - another-contributor
scripts: foo.script, bar.script
thumbnail: myimage.png
---
```

* Use the `author_ids` array for one or more contributors. The legacy `author` display-name field is also accepted for a single contributor and is resolved to an author ID by the website CI build when the name exactly matches a profile in the website author registry. Author IDs are stable lowercase kebab-case keys from the Defold website author registry; display names and profile metadata for ID-based authors do not belong in this repository.
* Examples use the repository-wide CC0-1.0 licence by default. Add a `license` field only when an example needs a different licence.
* List any scripts your example uses in the `scripts` field of the file header. A file name is enough when it is unique in the project. If multiple scripts have the same file name, use the exact path relative to the example project root (for example, `main/player/player.script`).
* The thumbnail image will be used on https://defold.com/examples 
