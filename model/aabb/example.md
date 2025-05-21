---
tags: model
title: AABB
brief: This example demonstrates how to use the `model.get_aabb()` function in a 3D scene.
scripts: aabb.script
author: Artsiom Trubchyk
---

This example shows how to work with Axis-Aligned Bounding Boxes (AABB) in a 3D scene. The setup consists of falling cubes that are dynamically tracked by a camera using their combined bounding box. The example demonstrates:

* How to create and manage a dynamic bounding box that updates with moving objects
* Using `model.get_aabb()` to get object bounds
* Camera positioning based on bounding box size
* Dynamic object spawning with factory
* Smooth camera transitions

Press SPACE or click to spawn new cubes. The camera will automatically adjust to keep all objects in view based on their combined bounding box.

The models used in this example are from Kenney's [Prototype Kit](https://kenney.nl/assets/prototype-kit), licensed under CC0.
