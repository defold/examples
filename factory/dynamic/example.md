---
tags: factory
title: Dynamic factories
brief: This example shows how to change the prototype game object used by a factory component.
scripts: dynamic.script
---

This example shows how to change the prototype game object used by a factory component. All prototype bullets are stored in a collection and referenced as a collection proxy. The collection proxy is never loaded, but it will ensure that the bullet prototypes are included in the build even though they are not immediately used by a factory. Another alternative is to load bullet prototypes using Live Update.

ship
: The red ship at the bottom. Contains:
  - A *Sprite* component with the spaceship image.
  - A *Factory* component to spawn bullet game objects. This component has the *Dynamic Protoype* option checked.
  - A *Collection Proxy* component referencing a collection containing all bullet types
  - A *Script* component to handle spawning of bullets.
