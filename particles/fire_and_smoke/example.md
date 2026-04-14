---
tags: particles
title: Particle effect example - fire and smoke
brief: This example shows a simple particle effect for imitating fire and smoke using two emitters and 3 modifiers in a single particlefx component.
author: Pawel Jarosz
scripts: fire_and_smoke.script
thumbnail: thumbnail.png
---

## Setup

The Particle Effect consists of two emitters: for fire and smoke. Each of them has tweaked properties. All combined creates a fire and smoke effect. There are also modifiers.

Both emitter use a simple radial gradient blob image from sprites.atlas.
Fire emitter is in front, because its Z position is 0.1, while smoke is at Z position equal to 0.

There are two modifiers that affect both emitters:

- Acceleration with Magnitude 70 +/- 10
- Radial with Magnitude: -30 +/- 40 positioned at Y = 150

Fire emitter has one additional modifier:

- Vortex with Magnitude 0 +/- 50 - simulating random fluctuations of the fire effect.

### Fire properties

Changed properties (from default):

- Blend Mode: Alpha (for transparency blending)
- Max Particle Count: 128
- Emitter Type: Circle
- Spawn Rate: 35 +/- 10
- Emitter Size X: 100 +/- 20 (for circle emitters only Emitter Size X is taken into account, as radius)
- Initial Speed: 30 +/- 20
- Initial Size: 80 +/- 10
- Initial Red: 1.0
- Initial Green: 0.5 +/- 0.1
- Initial Blue: 0.1
- Initial Alpha: 0.8 +/- 0.2 (for a little transparency)
- Initial Rotation: 180 (to make flame sprite upside down)

Additionally, the curves for Life Scale, Life Red, Life Green, and Life Alpha properties were adjusted:

![fire](fire.png)

### Smoke properties

Smoke emitter has a smoke animation from sprites.atlas.

It has two modifiers:

- Acceleration with Magnitude 20 +/- 10
- Radial with Magnitude: -40 +/- 20 positioned at Y = 150

Changed properties (from default):

- Position, Y: 60 (to emit a little bit above the fire)
- Start Delay: 0.5 +/- 0.3 (to start a little bit after fire)
- Blend Mode: Alpha (for transparency blending)
- Max Particle Count: 32
- Emitter Type: Circle
- Spawn Rate: 8 +/- 2
- Emitter Size X: 30 +/- 10  (for circle emitters only Emitter Size X is taken into account, as radius)
- Particle Life Time: 5 +/- 0
- Initial Speed: 10 +/- 10
- Initial Size: 40 +/- 20
- Initial Alpha: 0.5 +/- 0.3 (for a lot of transparency)
- Initial Rotation: 0 +/- 90 (to make intial rotation of smoke sprite random)

Additionally, the curves for Life Scale, Life Red, Life Green, Life Alpha and Life Alpha properties were adjusted:

![smoke](smoke.png)

The collection contains just a single game object with "particles" particlefx component and the script.
