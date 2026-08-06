# Defold examples

This repository includes the Defold examples used in the examples section on https://defold.com/examples

## Adding more examples
Examples are grouped by category, for instance "physics", "sprite" or "collection". Each group of examples has a folder in /examples. Here's how to add a new example named "foobar" to the "sprite" category:

* Create a folder named `foobar` in `examples/sprite`
* Create `examples/sprite/foobar/game.project` and the files required for your example
* Create `examples/sprite/foobar/example.md` with example documentation. The file must start with:

```
---
title: Foobar
brief: This example shows how to use foobar.
authors:
  - Defold Foundation
  - Another Contributor
scripts: foo.script, bar.script
thumbnail: myimage.png
---
```

* Use the `authors` array for one or more contributors. The older single `author` field is still supported for existing examples.
* Examples use the repository-wide CC0-1.0 licence by default. Add a `license` field only when an example needs a different licence.
* List any scripts your example uses in the `scripts` field of the file header. A file name is enough when it is unique in the project. If multiple scripts have the same file name, use the exact path relative to the example project root (for example, `main/player/player.script`).
* The thumbnail image will be used on https://defold.com/examples 
