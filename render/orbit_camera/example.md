---
name: Orbit Camera (3D)
tags: render
title: Orbit Camera
brief: This example demonstrates how to create script to control a 3D camera with the mouse. Scroll wheel is used to zoom in and out.
author: aglitchman
scripts: orbit_camera.script
---

In this example, we create a script to control a 3D camera using the mouse and mouse scroll wheel.

We added two objects to the collection: a camera (`/camera`) and an object (`/crate`) that we will explore. In the `camera` object, we added the `orbit_camera.script` - the script that controls the camera. The properties defined in the script are:
- `zoom`: the initial zoom level.
- `zoom_speed`: the speed of the zoom.
- `rotation_speed`: the speed of the rotation.
- `offset`: the offset of the camera from the origin. Use it to move the camera away from the origin.

During `init`, the script sets up the camera projection, acquires input focus, and establishes starting values for yaw, pitch, and zoom. 

In the `update` loop, the script smoothly interpolates camera rotation and zoom (note: `vmath.lerp` is used and it doesn't depend on the delta time, so the camera will move at different speed on different devices), calculates the camera's rotation and position based on current yaw, pitch, and zoom values, and then updates the camera's position and rotation accordingly. This creates a fluid, responsive camera movement!

The function `on_input` handles user input to control the camera. As the user moves the mouse or touches the screen, the script adjusts the yaw and pitch values, allowing the camera to rotate around its focal point. Additionally, it responds to mouse wheel input, adjusting the zoom level to move the camera closer to or further from the center point.

The model used in this example is from Kenney's [Prototype Pack](https://kenney.nl/assets/prototype-kit), licensed under CC0.
