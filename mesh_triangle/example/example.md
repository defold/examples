---
tags: mesh
category: mesh
title: Mesh
brief: This example shows how to create a basic mesh component in the shape of a triangle.
scripts: mesh.fp, mesh.vp
---

This example contains a game object with a mesh component in the shape of a triangle. The triangle is defined in `triangle.buffer` as the three points of the triangle in the `position` stream. The triangle also defines the colors at each point. The colors get mixed automatically when the triangle is drawn by the shader.

```
[
    {
        "name": "position",
        "type": "float32",
        "count": 3,
        "data": [
            -0.5, -0.5, 0,
            0.5, -0.5, 0,
            0.0, 0.5, 0
        ]
    },
    {
        "name": "color0",
        "type": "float32",
        "count": 4,
        "data": [
            0, 1, 0, 1,
            1, 0, 0, 1,
            0, 0, 1, 1
        ]
    }
]
```