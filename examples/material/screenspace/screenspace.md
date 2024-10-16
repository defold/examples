---
name: Screenspace (3D)
title: Screenspace
brief: This example shows how to create a custom material with two textures that blend together to create a pattern effect using screen space coordinates.
scripts: screenspace.script, screenspace.vp, screenspace.fp
---

In this example, we create a new material for 3D models in which we convert vertex coordinates to screenspace to get a special effect. It may be called "surface fill", "screenspace fill" and is used, most often in combination with outlines, to highlight objects in 3D games or indicate their status. 

We added two game objects and two models to which we assigned our new `screenspace` material. The material is based on [`unlit`](/examples/material/unlit/), but in it:
- vertex shader: we added a conversion of the clip space position to the screen position to pass that value to the fragment shader.
- fragment shader: we added sampling the color based on screenspace coordinates and blending into the final output color.
- material properties: we added a new sampler to set a second texture to be used as a pattern, and user-defined uniforms to control the fragment shader.

Then the script setups a perspective camera, activates it with the `acquire_camera_focus` message. The last important thing is to pass the screen size to the shader to adjust the aspect ratio:

```lua
local w, h = window.get_size()
go.set("#model", "screen_size", vmath.vector4(w, h, 0, 0))
```

The shaders are written in GLSL 1.40, which is available from Defold 1.9.2. The model used in this example is from Kenney's [Prototype Pack](https://kenney.nl/assets/prototype-kit), licensed under CC0.
