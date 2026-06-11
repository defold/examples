---
tags: physics, box2d
title: Box2D Chain Terrain
brief: Create Box2D chain terrain from script using scripting with Box2D V2 (legacy) and V3.
author: Defold Foundation
scripts: box2d_chain_terrain_v3.script, box2d_chain_terrain_v2.script
thumbnail: thumbnail.webp
---

This example creates connected Box2D chain terrain at runtime. It works with both Box2D V2 and V3 by attaching one script for each backend. Each script checks `b2d.get_version()` during `init()` and becomes a no-op when the other backend is active.

Click or tap the window to reset the ball and watch it roll over the same chain again.

## What You'll Learn

- How to get a Box2D body from a Defold collision object
- How to detect the active Box2D version with `b2d.get_version()`
- How to create chain terrain with `b2d.body.create_fixture()` in Box2D V2 Legacy Defold version.
- How to create chain terrain with `b2d.body.create_chain()` in Box2D V3.

## Setup

The collection contains a static `terrain` game object with one collision object. This is required because the runtime-created terrain is attached to an existing Box2D body. Defold creates that body from the collision object in the collection.

The small box shape on `terrain` sits below the view. It is only a placeholder that gives the script a static body to attach the runtime chain to; the visible terrain is the chain itself, drawn with `@render:draw_line`.

The `controller` game object has both backend scripts, a label, and a local factory component named `ball_factory`. The factory points at `/example/ball.go`, a shared prototype with one sprite and one dynamic circle collision object.

![setup](setup.png)

The `game.project` of this example is configured to build with `/box2D_V3.appmanifest` by default. To test V2 locally after downloading the example, change `Native Extensions -> App Manifest` in `game.project` to `/box2D_V2.appmanifest`.

![game_project](game_project.png)

## How It Works

Both scripts read `b2d.get_version()` once. `box2d_chain_terrain_v2.script` only continues when the major version is 2 (Defold legacy version), while `box2d_chain_terrain_v3.script` only continues when the major version is 3.

`b2d.get_body()` returns the Box2D body owned by the hidden `terrain` collision object. The active script then builds the chain with the backend-specific chain API.

In Box2D V2 Legacy Defold version., the script passes a chain shape definition to `b2d.body.create_fixture()`, which creates connected segments on the same static body.

In Box2D V3, the script uses `b2d.body.create_chain()`, which creates a true chain with segment adjacency and ghost vertices.

The shape definition includes `prev_vertex` and `next_vertex`. These are ghost vertices placed just outside the first and last terrain points. They do not add visible terrain segments; they tell Box2D how the open chain would continue past its endpoints so endpoint collision normals stay consistent.

The script redraws the chain vertices each frame with `@render:draw_line`, because the chain itself is a physics shape and has no sprite. The ball is created from the factory, given an initial velocity with `b2d.body.set_linear_velocity()`, and then reset on a timer or when the user clicks or taps.
