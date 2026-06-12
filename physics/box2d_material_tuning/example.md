---
tags: physics, box2d
title: Box2D Material Properties Tuning
brief: Tune Box2D density, friction, and restitution from script using Box2D V2 legacy and Box2D V3.
author: Defold Foundation
scripts: box2d_material_tuning_v3.script, box2d_material_tuning_v2.script
thumbnail: thumbnail.webp
---

This example compares three dynamic balls whose Box2D material properties are tuned from script. It works with both Box2D V2 legacy and Box2D V3 by attaching one script for each backend. Each script checks `b2d.get_version()` during `init()` and becomes a no-op when the other backend is active.

Click or tap the window to reset the balls and watch the comparison again.

## What You'll Learn

* How to get a Box2D body from a Defold collision object
* How to detect the active Box2D version with `b2d.get_version()`
* How to tune density, friction, and restitution through the V2 fixture API
* How to tune density, friction, and restitution through the V3 shape API
* How to switch the project between Box2D V2 and V3 with app manifests

## Setup

The collection contains three spawner game objects, one for each material: Ice, Rubber, and Gold. Each spawner has both backend scripts, a label, and a local factory component named `ball_factory`.

All three factories point at `/example/ball.go`, a shared prototype with one sprite and one dynamic circle collision object. The active script creates a ball at the spawner's position, tints the spawned sprite, applies the material settings, and gives it a starting velocity and spin from the spawner's script properties.

The material comparison comes from per-instance script property overrides:

<kbd>Ice</kbd>
: Low friction and low restitution, so the ball slides along the ramp.

<kbd>Rubber</kbd>
: Medium friction and high restitution, so the ball bounces more.

<kbd>Gold</kbd>
: High density, high friction, and low restitution, so the ball feels heavier and settles quickly.

The static scene is built from white walls, and three colored ramps.

![setup](setup.png)

The `game.project` of this example is configured to build with `/box2d_v3.appmanifest` by default. To test V2 locally after downloading the example, change `Native Extensions -> App Manifest` in `game.project` to `/box2d_v2.appmanifest`.

![game_project](game_project.png)

## How It Works

Both scripts read `b2d.get_version()` once. `box2d_material_tuning_v2.script` only continues when the major version is 2, while `box2d_material_tuning_v3.script` only continues when the major version is 3.

`go.property()` exposes the material settings on each script instance. The Ice, Rubber, and Gold spawners use the same scripts, but each spawner overrides density, friction, restitution, velocity, spin, tint, and material name in the collection.

`b2d.get_body()` returns the Box2D body owned by the spawned ball's collision object. The active script then updates the ball with the backend-specific material API.

There is a significant difference between Box2D V2 legacy and Box2D V3.

In Box2D V2 legacy, collision geometry and material properties are attached to a body through fixtures. The V2 script reads the first fixture with `b2d.body.get_fixtures()` and uses `b2d.fixture.set_density()`, `b2d.fixture.set_friction()`, and `b2d.fixture.set_restitution()` to tune the ball. When setting density, the script asks Box2D to update the body mass from the new value.

In Box2D V3, the script uses the shape API instead of the V2 fixture API. It reads the first shape with `b2d.body.get_shapes()` and uses `b2d.shape.set_density()`, `b2d.shape.set_friction()`, and `b2d.shape.set_restitution()`. After changing density, it calls `b2d.body.reset_mass_data()` so the body mass reflects the new density immediately.

After applying the values, each script reads them back and shows them on the label attached to the same spawner. Clicking or tapping makes each active spawner delete its current ball, spawn a fresh one from its own factory, and reapply its material settings for the current backend.
