# Defold examples

This repository includes the Defold examples used in the examples section on https://defold.com/examples

## Adding more examples
Examples are grouped by category, for instance "physics", "sprite" or "collection". Each group of examples has a folder in /examples. Here's how to add a new example named "foobar" to the "sprite" category:

* Create a folder named `foobar` in `examples/sprite`
* Create `examples/sprite/foobar/foobar.collection` with your example
* Create `examples/sprite/foobar/foobar.md` with example documentation. The file must start with:

```
---
title: Foobar
brief: This example shows how to use foobar.
scripts: foobar.script
---
```

* List any scripts your example uses in the `scripts` field of the file header
* Add a new collection proxy in `examples/_main/loader.go`
* Add a new entry in `examples/_main/menu.gui_script`
