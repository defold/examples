---
name: Look rotation (3D)
tags: movement
title: Look rotation
brief: This example shows how to rotate a game object to look at the object in 3D space.
author: aglitchman
scripts: look_rotation.script
---

This example shows how to orient a game object to look at the target game object in 3D space. For this purpose, we created the function `quat_look_rotation` (also called `LookRotation` or `looking_at` in the industry). This function creates a rotation matrix from the forward and upwards vectors and then converts it to a quaternion. The function also handles the case where no upwards direction is specified, using the default (0, 1, 0) in that case.

Note: to properly apply the resulting rotation, you must remember that your game object must face backwards to the "z" axis, i.e. in Defold the "forward" direction is vector (0, 0, -1).

In this demo you can rotate the camera by holding down the mouse button. And also switch "targets" by pressing any key.

The models used in this example are from Kenney's [Prototype Kit](https://kenney.nl/assets/prototype-kit), licensed under CC0.
