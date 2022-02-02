---
title: Knockback
brief: This example shows how to create a knockback effect when hit.
scripts: enemy.script
---

This example shows how to create a knockback effect when hit. The setup consists of three game objects; one for the player, one for the enemy and one for the bullet that is spawned using a factory (see example on how to spawn bullets).

player
: The red ship at the bottom. Contains:
  - A *Sprite* component with the spaceship image.
  - A *Factory* component to spawn bullet game objects
  - A script to handle spawning of bullets.

bullet
: The bullet fired by the player. Contains:
  - A *Sprite* component with a bullet image.
  - A *Collision object* component. *Type* is set to `KINEMATIC`. It has a sphere *Shape* matching image.

enemy
: The black ship at the top. Contains:
  - A *Sprite* component with the spaceship image.
  - A *Collision object* component. *Type* is set to `KINEMATIC`. It has a sphere *Shape* matching image.
  - A script to handle collisions with bullets.
