---
tags: particles
title: Particle Effect Emission Space
brief: This example demonstrates the difference between local and world particle emission spaces. Two UFO objects move up and down, showing how particles behave differently when emitted in emitter space versus world space.
author: Defold Foundation
scripts: particlefx.script
thumbnail: thumbnail.png
---

This example shows how particle emission space affects particle behavior when the emitter object moves. The setup consists of two UFO objects with identical particle effects, but different emission space settings.

The example collection consists of 2 game objects that differ only in the particlefx used:

- particlefx on the left has Emission Space property set to "Emitter":
![Emission Space: Emitter](emitter.png)

- particlefx on the right has Emission Space property set to "World":
![Emission Space: World](world.png)

Both game objects are animated up and down, so that you can see the difference between the emission space:

![Screenshot showing particle emission space comparison](thumbnail.png)

Particles emitted in emitter space are "moving" with the object, so their position is always respective to the emitter actual origin.

Particles emitted in world space have positions respective to the world coordinates.

Use this example to understand when to use local vs world emission space in your particle effects!

