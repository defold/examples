---
tags: model
title: AABB - framing objects with a camera
brief: This example shows how to use `model.get_aabb()` to frame moving 3D objects with a camera.
scripts: aabb.script
author: Artsiom Trubchyk
thumbnail: thumbnail.webp
---

An axis-aligned bounding box, or AABB, is the smallest box aligned to the world X, Y, and Z axes that contains an object. Because it is described by only two corners, `min` and `max`, it is cheap to compare, combine, and use for visibility or spatial tests.

This example spawns falling crate models and keeps the camera focused on all visible crates. Each crate reports its local AABB, and the script combines those bounds into one scene-sized box used for camera placement.

Press SPACE, click, or touch the screen to spawn another crate.

## What You'll Learn

- How to read the local bounds of a Model component with `model.get_aabb()`
- How to combine several local AABBs into one world-space bounding box
- How to position a perspective camera from the combined bounds
- How to spawn model game objects from factories

## Setup

The collection contains three game objects: `camera`, `main`, and `ground`.

<kbd>camera</kbd>
: Contains a perspective Camera component. `aabb.script` reads its field of view and orientation, then moves it each frame so the combined bounds stay visible.

<kbd>main</kbd>
: Contains `aabb.script` and two Factory components. The factories spawn `/example/box1.go` and `/example/box2.go`, which are crate model game objects using two Kenney crate glTF assets.

<kbd>ground</kbd>
: Contains a static 3D collision object and a simple sprite plane. The crates fall onto this surface so the tracked bounds keep changing as new crates are added.

![setup](setup.webp)

## How It Works

`model.get_aabb()` returns the model's local-space bounds. For a crate, that means the two corners of a box that encloses the crate mesh before the game object position is applied. The box stays axis-aligned, so the script can merge many crates by taking the smallest X, Y, and Z values for the combined `min` corner and the largest values for the combined `max` corner.

When a crate is spawned, the script stores its local AABB. Every frame, it adds the crate's current game object position to that local `min` and `max`, turning the bounds into world-space values before comparing them with the accumulated scene bounds.

The combined AABB describes the full pile of crates. The script computes a center point and radius from the combined corners, smooths those values with `vmath.lerp()`, and places the camera far enough away for that radius to fit inside the camera field of view.

Input creates another crate through one of the two factories. The same bounds update code then expands the camera target automatically, so the full pile remains in view.

## Credits

The models used in this example are from Kenney's [Prototype Kit](https://kenney.nl/assets/prototype-kit), licensed under CC0.
