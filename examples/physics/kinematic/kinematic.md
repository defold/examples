---
title: Kinematic physics
brief: This example shows a simple setup with a kinematic physics objects. The difference between dynamic objects, simulated by the physics engine, and kinematic objects, that are user controlled, is clearly seen here.
scripts: kinematic.script
---

![kinematic](kinematic.png)

The setup consists of three game objects. The *game.project* physics *GravityY* property is set to -500 to match the scale of the setup.

block
: The square stone block. Contains:
  - A *Sprite* component with the stone block image.
  - A *Collision object* component. The *Type* is set to `KINEMATIC`. A box *Shape* matching the sprite image is added to the components.
  - A script that moves the game object to where the user clicks.

block2
: The rectangular stone block. Contains:
  - A *Sprite* component with the stone block image.
  - A *Collision object* component. Also has *Type* set to `DYNAMIC`, *Friction* set to 0 and *Restitution* to 1.0. A box *Shape* matching the sprite image is added to the components.

walls
: The outer walls. Contains:
  - A *Collision object* component. The *Type* is set to `STATIC`. 4 box *Shapes* are added to the component. These are placed just outside of the game view.
