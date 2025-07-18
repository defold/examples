---
name: Vertex Color (3D model)
tags: model
title: Unlit
brief: This example demonstrates how to apply a vertex color shader using exported attributes from a 3D model.
author: Agustin R.
scripts: vertexcolor.fp, vertexcolor.fp
---

Vertex color attributes are usually made up as a vector4 of floats represented as rgba(red, green, blue, alpha) channels. They can be applied to 3d models and exported from many 3d editor applications and are commonly used in games for many effects. This example we are displaying a 3d model with vertex color attribute through a shader. No textures or uv's are used to display the colors.

A game object with a model that has a `vertexcolor` material applied to it. The material is assigned custom vertex and fragment shaders. The shader is very simple and just transfers the vertex color data from the model to the vertex and fragment program to display them. The shaders are written in GLSL 1.40, which is available from Defold 1.9.2.

