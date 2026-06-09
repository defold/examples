---
tags: physics, box2d
title: Box2D Chain Terrain
brief: Create a Box2D chain fixture from script and use it as runtime terrain.
author: Defold Foundation
scripts: box2d_chain_terrain.script
thumbnail: thumbnail.webp
---

This example creates a connected chain of Box2D segment shapes at runtime. A dynamic ball rolls over the chain while the script draws the same vertices so the generated terrain is visible.

Click or tap the window to reset the ball and watch it roll over the same chain again.

## What You'll Learn

- How to get a Box2D body from a Defold collision object
- Why a runtime fixture needs an existing body to own it
- How to create a Box2D chain fixture with `b2d.body.create_fixture()`
- How to use `b2d.shape.SHAPE_TYPE_CHAIN` to make a runtime terrain

## Setup

The collection contains a static `terrain` game object with one collision object. This is required because `b2d.body.create_fixture()` does not create a standalone terrain object; it adds a fixture to an existing Box2D body. Defold creates that body from the collision object in the collection.

The small box shape on `terrain` sits below the view. It is only a placeholder that gives the script a static body to attach the runtime chain to; the visible terrain is the chain fixture drawn by the script.

The `controller` game object has the script, a label, and a local factory component named `ball_factory`. The factory points at `/example/ball.go`, a shared prototype with one sprite and one dynamic circle collision object.

![setup](setup.png)

## How It Works

`b2d.get_body()` returns the Box2D body owned by the hidden `terrain` collision object. The script passes that body and a chain shape definition to `b2d.body.create_fixture()`, which creates connected segments on the same static body.

The shape definition also includes `prev_vertex` and `next_vertex`. These are ghost vertices placed just outside the first and last terrain points. They do not add visible terrain segments; they tell Box2D how the open chain would continue past its endpoints so endpoint collision normals stay consistent.

The script redraws the chain vertices each frame with `@render:draw_line`, because the chain itself is a physics shape and has no sprite.

The ball is created from the factory, given an initial velocity with `b2d.body.set_linear_velocity()`, and then reset on a timer or when the user clicks or taps.
