---
tags: factory
title: Spawn enemies with central management
brief: This example shows how to spawn enemy game objects using a factory component and use a central manager to control movement and behavior of all enemies.
author: Defold Foundation
scripts: ship.script, spawner.script
thumbnail: thumbnail.png
---

This example shows how to dynamically spawn enemy game objects using a factory component and use a central manager to control movement and behavior of all enemies. The setup consists of three main components: a player ship, enemy spawner, and different enemy types with customizable properties.

Press keys `1`, `2`, or `3` to spawn different enemy types.

Example collection consists of 2 game objects:

![Screenshot showing enemy types and spawner in action](collection.png)

### Ship
The red ship at the bottom that automatically moves and shoots. Consists of:
- A *Factory* component `bulletfactory` to spawn bullet game objects
- A *Script* `ship` that handles automatic movement (ping-pong animation) and bullet spawning every 0.25 seconds
- A *Sprite* component with the spaceship image

Bullets are simply animated upward and automatically deleted when they reach the top.

### Spawner
Controls enemy spawning with keyboard input. Consists of:
- A *Factory* `enemyfactory` to spawn enemies with different properties
- A *Label* `example_description` with instructions text displayed on top
- A *Script* `spawner` that spawns enemies.


The spawner script defines three different enemy types: `random`, `diagonal`, and `straight`.
Uses a factory to create enemies and store their ids and properties in a look-up table:

```lua
local properties = ENEMY_TYPES[enemy_type]
local id factory.create("#enemyfactory", position)

self.enemies[id] = { ... }
```

The spawner script handles enemy movement by looping over the list of currently spawned enemies in the `update()` lifecycle function. It also uses a physics event listener to detect any enemy to bullet collisions. The spawner script also deletes enemy objects and removes them from the look-up table.

### Enemy Types

**Random Enemy** (Key 1):
- Green UFO sprite
- 1 health point
- Random horizontal movement that changes every second
- Speed: 40 horizontal, -100 vertical

**Diagonal Enemy** (Key 2):
- Red enemy sprite
- 2 health points
- Fixed diagonal movement
- Speed: 120 horizontal, -80 vertical

**Straight Enemy** (Key 3):
- Blue enemy sprite
- 3 health points
- Straight downward movement
- Speed: 0 horizontal, -40 vertical


Combine this example with other movement and physics examples to create a complete shoot'em up game!
