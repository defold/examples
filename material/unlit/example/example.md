---
name: Unlit (3D)
tags: material
title: Unlit
brief: This example demonstrates how to create and apply an custom non-lit material to a 3D model.
scripts: unlit.vp, unlit.fp
---

In industry-established terms, a material that is not affected by lighting is called "unlit" or "non-lit". It is used to create retro-style graphics or for effects that should not depend on lighting (headlights, lamps).

This example contains a game object with a model that has an `unlit` material applied to it. The material is assigned custom vertex and fragment shaders. The shader is very simple and just transfers the texture color to the model. This is an excellent starting point for creating new materials and for creating effects that do not depend on lighting. The shaders are written in GLSL 1.40, which is available from Defold 1.9.2.

The model used in this example is from Kenney's [Train Pack](https://kenney.nl/assets/train-kit), licensed under CC0.
