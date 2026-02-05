---
tags: mesh
title: Textured Mesh
brief: This example shows how to create a textured mesh component in the shape of a rectangle.
author: Defold Foundation
scripts: texturedmesh.fp, texturedmesh.vp
---

This example contains a game object with a mesh component in the shape of a rectangle (quad). The quad is defined in `quad.buffer` as the four points (triangle strip) in the `position` stream. The triangle also defines the texture coordinate (UV) at each point.

```
[
    {
        "name": "position",
        "type": "float32",
        "count": 3,
        "data": [
            -0.5, -0.5, 0,
             0.5, -0.5, 0,
            -0.5,  0.5, 0,
             0.5,  0.5, 0
        ]
    },
    {
        "name": "texcoord0",
        "type": "float32",
        "count": 2,
        "data": [
            0.0, 0.0,
            1.0, 0.0,
            0.0, 1.0,
            1.0, 1.0
        ]
    }
]
```

Texture by [Kenney.nl](https://kenney.nl/assets/prototype-textures)