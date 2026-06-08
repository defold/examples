---
tags: physics, box2d
title: Box2D Material Properties Tuning
brief: Set Box2D fixture density, friction, and restitution from script.
author: Defold Foundation
scripts: box2d_material_tuning.script
thumbnail: thumbnail.webp
---

This example compares three dynamic balls whose collision object fixtures are tuned from script. Each lane is a separate spawner game object with its own label, factory, and editable script properties for the material values.

Click or tap the window to reset the balls and watch the comparison again.

## What You'll Learn

- How to get a Box2D body from a Defold collision object
- How to read the first fixture index with `b2d.body.get_fixtures()`
- How to set fixture `density`, `friction`, and `restitution` at runtime

## Setup

The collection contains three spawner game objects, one for each material: Ice, Rubber, and Gold. Each spawner has the same script, a label component, and a local factory component named `ball_factory`.

All three factories point at `/example/ball.go`, a shared prototype with one sprite and one dynamic circle collision object. The script creates the ball at the spawner's position, tints the spawned sprite, and gives it starting velocity and spin from the spawner's script properties.

The material comparison comes from per-instance script property overrides:

<kbd>Ice</kbd>
: Low friction and low restitution, so the ball slides along the ramp.

<kbd>Rubber</kbd>
: Medium friction and high restitution, so the ball bounces a bit.

<kbd>Gold</kbd>
: High density, high friction, and almost no restitution, so the ball settles quickly.

The static scene is built from walls, two lane dividers, and three ramps. The ramps use the `pixel_blue`, `pixel_orange`, and `pixel_gold` atlas animations to match the three spawner labels.

![setup](setup.png)

## How It Works

`go.property()` exposes the material settings on each script instance, so the Ice, Rubber, and Gold spawners can use the same script with different values in the editor. The label is addressed as `#label`, because it is attached to the same game object as the script.

`b2d.get_body()` returns the Box2D body owned by the spawned collision object. The script then calls `b2d.body.get_fixtures()` and uses the first fixture's index with the `b2d.fixture` functions.

`b2d.fixture.set_density()` changes how much mass the fixture contributes to the body. The example passes `true` for `update_mass`, so Box2D recalculates the body mass immediately after the density change.

`b2d.fixture.set_friction()` and `b2d.fixture.set_restitution()` change how the body interacts with the ramps and walls. Clicking or tapping makes each spawner delete its current ball, spawn a fresh one from its own factory, and reapply its material settings.
