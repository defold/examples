---
name: Look at
tags: movement
title: Look at
brief: This example shows how to rotate a game object to look at the mouse cursor
scripts: look_at.script
---

This example shows how to rotate a game object to look at the mouse cursor. It reads the mouse position in `on_input` and uses the mathematical function `math.atan2(x, y)` to calculate the angle between the ray to the point to look at and the positive x-axis. This angle is used to set the rotation of the game object to always look at the mouse position. 

The example is suitable for the movement in two dimensions, for platformers or top-down games. For 3D objects, check out the [next example](/examples/movement/look_rotation/).
