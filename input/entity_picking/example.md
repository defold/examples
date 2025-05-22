---
tags: input
title: Entity Picking
brief: This example demonstrates how to pick a game object from the 3D scene.
author: Artsiom Trubchyk
scripts: entity_picking.script
---

This example describes method of selecting a game object from the 3D scene on the click of the mouse using collision-based picking:

* We use [collision object components](https://defold.com/manuals/physics-objects/) to define a pickable shape for each relevant game object. This example uses 3D physics, which is enabled in the `game.project` file.
* When the user clicks the mouse button, we convert screen coordinates to world coordinates and fire a raycast into the 3D world using the `physics.raycast()` function.
* If the ray intersects with a collision object, the corresponding game object is considered "picked".

The models used in this example are from Kenney's [Prototype Kit](https://kenney.nl/assets/prototype-kit), licensed under CC0.
