---
tags: factory
title: Shoot bullets with script properties
brief: This example shows how to spawn bullet game objects using a factory component with different properties.
author: Defold Foundation
scripts: player.script, bullet.script
thumbnail: thumbnail.png
---

This example shows how to dynamically spawn bullet game objects using a factory component with different properties. The setup consists of two game objects; one for the player and one for the bullet that is spawned using a factory component wit properties definition:

```
local properties = {
  speed = self.bullets_speed,
  animation = self.bullets_type
}

factory.create("#bulletfactory", pos, nil, properties)
```

player
: The red ship at the bottom. Contains:
  - A *Sprite* component with the spaceship image.
  - A *Factory* component to spawn bullet game objects
  - A script to handle spawning of bullets.
  - An additional *sprite* to indicate what type of bullets is selected now.

bullet
: The bullet fired by the player. Contains:
  - A *Sprite* component with a bullet image.
  - A script to handle bullet animation and movement.

Properties added to `bullet.script` define what it looks like and how fast it goes. When bullet have `go.property` defined in its script - the properties will be also visible in the *Properties* pane:

![bullet script with properties](<assets/images/bullet.png>)


Combine this example with some of the examples from the movement and physics categories to create a shoot 'em up game!