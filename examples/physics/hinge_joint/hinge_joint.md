---
title: Hinge joint physics
brief: This example shows a simple setup with a dynamic body physics object and two dynamic wheel physics object joined together with a joint of type "hinge". The hinge joint can simulate an axle or a pin on which other object is rotating in respect to the base. The example shows how to create, destroy and change properties of the joints.
scripts: hinge_joint.script
---

![hinge_joint](hinge_joint.png)

The setup consists of four game objects. The *game.project* physics *GravityY* property is set to -500 to match the scale of the setup.

body
: The square stone block. Contains:
  - A *Sprite* component with the stone block image.
  - A *Collision object* component. The *Type* is set to `DYNAMIC`. A box *Shape* matching the sprite image is added to the components.
  - A script that joines the wheel game objects to to the body and reacts to user input by changing the direction of the rotation of the hinge joints.
  - A label with an instruction to the user.

frontwheel
: The cirular metal wheel. Contains:
  - A *Sprite* component with the metal circle image.
  - A *Collision object* component. Also has *Type* set to `DYNAMIC`, *Friction* set to 0.9 and *Restitution* to 0.1. A box *Shape* matching the sprite image is added to the components.

backwheel
: The same as above.

walls
: The outer walls. Contains:
  - A *Collision object* component. The *Type* is set to `STATIC`. 4 box *Shapes* are added to the component. These are placed just outside of the game view.
