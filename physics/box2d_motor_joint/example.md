---
tags: physics, box2d
title: Box2D Motor Joint
brief: Create and control a motorized Box2D joint from script using Box2D V2 and V3.
author: Defold Foundation
scripts: box2d_motor_joint_v3.script, box2d_motor_joint_v2.script
thumbnail: thumbnail.webp
---

This example creates a motorized Box2D joint at runtime. It works with both Box2D V2 and V3 by attaching one script for each backend. Each script checks `b2d.get_version()` during `init()` and becomes a no-op when the other backend is active.

Click or tap the window to reverse the motor direction.

## What You'll Learn

- How to get Box2D body handles from Defold collision objects
- How to detect the active Box2D version with `b2d.get_version()`
- How to create a pivoted motor joint with `b2d.joint.create_revolute()`
- How to control joint motor speed with `b2d.joint.set_motor_speed()`
- How to tune the Box2D V3 joint solver with `b2d.world.set_joint_tuning()`

## Setup

The collection contains a static `pivot` game object, one dynamic `arm` game object with a particle effect, and a controller game object.

The `pivot` object marks the world point the arm should rotate around. The `arm` object is the dynamic body driven by the joint. The example uses a revolute joint with its motor enabled, because the revolute joint provides a stable hinge pivot while the motor drives the rotation.

The controller has both backend scripts attached. Each script checks `b2d.get_version()` and only runs when the selected app manifest matches its Box2D backend.

![setup](setup.png)

The `game.project` of this example is configured to build with `/box2D_V3.appmanifest` by default. To test V2 locally after downloading the example, change `Native Extensions -> App Manifest` in `game.project` to `/box2D_V2.appmanifest`.

![game_project](game_project.png)

## How It Works

Both scripts read `b2d.get_version()` once. `box2d_motor_joint_v2.script` only continues when the major version is 2, while `box2d_motor_joint_v3.script` only continues when the major version is 3.

`b2d.get_body()` returns the Box2D bodies owned by the `pivot` and `arm` collision objects. The active script then creates a revolute joint between those bodies with `b2d.joint.create_revolute()`.

The joint definition uses:

- `local_anchor_a` on the pivot body
- `local_anchor_b` on the arm body
- `enable_motor` to turn on the joint motor
- `max_motor_torque` to limit how strongly the motor can rotate the arm
- `motor_speed` to set the current motor direction and speed

The important part is the arm anchor. The pivot is placed in the collection as a visible reference point. The scripts convert that world position into the arm's local space, so the arm rotates around the same visible pivot instead of rotating around its center.

Click or tap to reverse the motor with `b2d.joint.set_motor_speed()`. The V3 script also calls `b2d.world.set_joint_tuning()` to adjust the joint solver used by the Box2D V3 backend.
