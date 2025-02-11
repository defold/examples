---
tags: particles
title: Particle effect example - fireworks
brief: This example shows a fireworks effect made with particles.
scripts: fireworks.script
---

This effect consists of two particle effects: trail and bang. In this example there are three different colors, which could be easily changed in particle emitters settings.


The main script `fireworks.script` spawns the fireworks trail particlefx on startup or when any key is pressed or the mouse button is clicked. It also has a timer that spawns the particlefx in a loop with a 3 second delay. 

To start effect:
- add factories for splat and trail particles;
- call "start_fireworks" method with parameters (time, start point, speed vector).

Images for particles are taken from Kenney Particle Pack.