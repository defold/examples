---
tags: model, animation
title: Morph Target Animation
brief: Shows how to play glTF morph target animations on a Model component.
author: Defold Foundation
scripts: morph_target.script
thumbnail: thumbnail.webp
---

This example plays morph target animations from a glTF model. The model uses Defold's built-in model material, so no custom shader is needed to see the animated shape changes.

## What You'll Learn

- How to use a glTF file that contains morph targets and weight animations
- How to play a named model animation with `model.play_anim()`
- How to cycle between several morph target animations with input
- How the built-in model material can render animated morph targets

## Setup

The collection contains one camera and one `morph_target` game object.

<kbd>morph_target</kbd>
: Contains a Model component, `morph_target.script`, and `info.gui`. The Model component uses `/assets/models/MorphStressTest.glb` for mesh, skeleton, and animation data. The glTF file contains eight morph targets and three animations: `TheWave`, `Pulse`, and `Individuals`.

<kbd>camera</kbd>
: Contains a perspective Camera component positioned above and in front of the model.

The glTF model has two material slots, `Base` and `TestMaterial`. Both slots use `/builtins/materials/model.material`; the blue and orange textures only make the two parts of the model easier to distinguish.

![setup](setup.png)

## How It Works

`morph_target.script` stores the animation names in a small table. In `init()`, it acquires input focus and starts `TheWave` with:

```lua
model.play_anim("#model", "TheWave", go.PLAYBACK_LOOP_FORWARD)
```

The animations in the glTF file target the model's morph weights. As the animation plays, Defold updates those weights and the built-in model material renders the deformed mesh.

When you click or touch the screen, `on_input()` advances to the next animation name and calls `model.play_anim()` again. The example loops through `TheWave`, `Pulse`, and `Individuals`.

## Credits

The `MorphStressTest.glb` asset is CC-BY 4.0, Copyright 2021 Analytical Graphics, Inc. Model by Ed Mackey.
[https://github.com/KhronosGroup/glTF-Sample-Assets/tree/main/Models/MorphStressTest](https://github.com/KhronosGroup/glTF-Sample-Assets/tree/main/Models/MorphStressTest)
