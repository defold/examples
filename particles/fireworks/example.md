---
tags: particles
title: Spawning Fireworks ParticleFX
brief: This example shows how to spawn firework rockets with separate trail and burst particle effects, including a small dip before the burst.
author: fysx, Defold Foundation
scripts: fireworks.script
thumbnail: thumbnail.png
---

## Setup

The collection contains:

- one controller game object with `fireworks.script`;
- six embedded factories: one `trail` factory and one `splat` factory for each of the three colors;
- one GUI component that shows the click/tap instruction on screen.

Each firework is built from two separate particlefx game objects:

- a looping `trail` effect that represents the rocket while it is flying;
- a one-shot `splat` effect that represents the explosion at the end.

The script does not use `update()`. It spawns the trail object, animates it with `go.animate()`, and starts the burst effect from the animation callback when the flight finishes.

![Fireworks particle effect](setup.png)

## Trail particlefx

Each `trail` particlefx file contains one looping cone emitter. The three color variants share the same setup and only differ in their base RGB values.

The trail emitter uses:

- `Emmision Space` : `World`, so emitted particles stay behind in world space instead of following the moving game object;
- `Particle Orientation` : `Movement direction`;
- additive blending;
- the `fw_circle_01` sprite from `/assets/sprites.atlas`;
- a spawn rate of `64`, particle lifetime `0.6`, and particle size around `40` with a small spread.

Because the sprite is a soft circle rather than a directional streak, the trail reads more like a glowing puff stream than a sharp rocket spark. The scale and alpha curves in the emitter make each particle start fairly full, then shrink and fade out quickly.

The trail game object itself is prepared by the script before the animation starts:

- position is set near the bottom of the screen;
- scale is animated down over time so the trail feels like it is burning out before the explosion.

## Burst particlefx

Each `splat` particlefx file is a one-shot layered burst built from five circle emitters. The red, green and blue files use the same emitter structure and timings, with color values changed per variant.

The five burst layers are:

- a `fw_trace_01` streak layer with movement-direction orientation, about `64` particles, lifetime around `1.6`, speed around `200`, and velocity stretching;
- a `fw_star_01` star layer with angular-velocity orientation, about `30` particles, lifetime around `1.6`, speed around `300`, and randomized rotation;
- a second `fw_trace_01` streak layer with additive blending for extra brightness;
- a `fw_light_01` flash layer that emits a single large soft light particle;
- a second additive `fw_light_01` layer that adds a smaller glow on top of the main flash.

The moving burst layers also use modifiers. The streak layers use acceleration, and the star and additive streak layers also use radial shaping, so the burst does not expand as a perfectly uniform circle. The two `fw_light_01` emitters do not throw particles outward; they behave more like expanding flashes at the center of the explosion.

Like the trail, the burst emitters also use `Emmision Space` : `World`, so the explosion stays fixed at the burst position after it has been spawned.

## Script and spawning

The script handles spawning in three ways:

- it launches one firework in `init()`;
- it starts a repeating timer that launches another firework every 3 seconds;
- it launches another firework when the left mouse button is pressed, which also works as click/tap input in the example.

To keep the effect under control, the script allows at most 16 active fireworks at the same time.

`spawn_firework()` first checks that limit. It then:

- picks a random color from `red`, `green` and `blue`;
- creates the matching trail and burst game objects with `factory.create()`;
- generates a random launch angle, launch strength and flight time;
- computes the initial position near the bottom of the screen, a peak position, and a burst position slightly below that peak;
- starts the trail particlefx;
- starts `go.animate()` for `position.x`, `position.y` and `scale`.

The values that control this motion are collected at the top of the script, including:

- launch strength and angle range;
- start position and horizontal spread;
- flight time and flight-distance ratio;
- how much of the total flight is used for the final dip;
- the minimum and maximum distance of that dip.

The rocket flight uses two separate property animations:

- `position.x` uses linear easing;
- `position.y` first uses `go.EASING_OUTQUAD` to rise to the peak, then `go.EASING_INQUAD` to dip slightly before the burst;
- `scale` is animated down during the flight.

Using different easing for X and Y gives a simple curved flight path without a manual simulation loop. Splitting the Y animation into two phases lets the rocket rise, dip a little, and then explode. When the second Y animation finishes, its completion callback stops and deletes the trail object, reads its final position, and plays the burst effect there. A separate one-shot timer then deletes the burst object after a short cleanup delay.

To reuse this setup in another project:

- add factories for the trail and burst particlefx game objects;
- spawn both objects with `factory.create()`;
- choose a start position, a target position and a flight time;
- animate the trail object with `go.animate()`;
- trigger and clean up the burst effect from the animation callback.

Particle sprites are CC0 from Kenney Particle Pack.
