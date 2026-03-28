---
tags: particles
title: ParticleFX emitter properties
brief: This example shows how to get and set ParticleFX emitter image, animation, and material at runtime.
author: Defold Foundation
scripts: particlefx_set_get.script, particlefx_glow.fp
thumbnail: thumbnail.png
---

Since Defold 1.12.2 you can use `go.get()` and `go.set()` on individual ParticleFX emitters by passing `keys = { "..." }`.

This example focuses on this feature. It toggles a ParticleFX between two setups and shows the properties of the active emitters in the labels.

## Setup

1. Example consists of one game object in the collection having:

   - script `particlefx_set_get.script`
   - ParticleFX component named `#particles`
   - 2 label components: `#label_core` and `#label_spark`
   ![Outline](outline.png)

2. The ParticleFX:

   - has two emitters: `emitter_top` and `emitter_bottom`
   ![ParticleFX](particlefx.png)

3. The script has the resources exposed as properties:

   - `particles_atlas`
   - `sprites_atlas`
   - `default_material`
   - `glow_material`

   This makes it easy to switch the emitter `image` and `material` directly from code.

4. The example uses 2 atlases with given animations:

   - the `particles.atlas` with `coin` and `smoke` animations
   - the `sprites.atlas` with `ship_red` and `ship_dark` animations

The atlases are set up to contain the animation ids used by the script, so the example can switch between the two setups without extra transition logic.

## How it works

The script keeps two hardcoded setups and toggles between them whenever you click or tap:

1. `particles.atlas` + glow material
   `emitter_top` uses `coin`
   `emitter_bottom` uses `smoke`
2. `sprites.atlas` + default particle material
   `emitter_top` uses `ship_red`
   `emitter_bottom` uses `ship_dark`

When the setup changes, the script:

1. stops the ParticleFX
2. calls `set_emitter_properties()` for each emitter to set `image`, `animation`, and `material`
3. calls `get_emitter_properties()` to read the current values back with `go.get()`
4. writes the values into the two labels
5. plays the ParticleFX again

The helper function `set_emitter_properties()` applies properties per emitter by passing the emitter id in `keys`:

```lua
go.set("#particles", "image", image, { keys = { "emitter_top" } })
go.set("#particles", "animation", animation, { keys = { "emitter_top" } })
go.set("#particles", "material", material, { keys = { "emitter_top" } })
```

The helper function `get_emitter_properties()` uses the same `keys` pattern with `go.get()` and writes the result into the labels, so the example shows which values are currently active for each emitter.

One important limitation: **emitter property changes only affect the next play**. That is why the script stops and plays the ParticleFX around each property update.
