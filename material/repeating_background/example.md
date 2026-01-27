---
name: Repeating Background
tags: material
title: Repeating Background
brief: Create a scrolling background using a repeating texture on a model quad.
author: aglitchman
scripts: repeating_background.script, repeating_background.vp, repeating_background.fp
---

A repeating, scrolling texture can add visual interest to a static background. This example demonstrates how to create an infinitely tiling background using a model quad with a repeating texture. The effect is achieved by scrolling the UV coordinates over time, creating smooth, continuous motion.

The script driving the effect works as follows:

* Each frame it reads the current window size and scales the `background` game object so the quad covers the full viewport. The rotation is set via `euler.z` (Rotation Z in the IDE).
* It converts the window size into a UV repeat scale (`uv_params.x/y`) so the texture tiles across the screen.
* It advances a scrolling offset based on `scroll_speed` and `tile_size`, wraps it to the 0..1 range, and sends `uv_params` to the model material.

The asset used in this example is from Kenney's [Puzzle Pack 2](https://www.kenney.nl/assets/puzzle-pack-2), licensed under CC0.
