---
tags: render
title: World to Screen
brief: This example demonstrates how to convert 3D world coordinates to 2D screen coordinates using camera transformations.
author: Artsiom Trubchyk
scripts: player.script
thumbnail: thumbnail.png
---

This example shows how to convert world positions to screen coordinates for UI positioning. It features:

* Use of the built-in `camera.world_to_screen()` API to transform 3D world positions to 2D screen coordinates.
* A reference Lua `world_to_screen()` implementation (below) kept as an example to help understand how the conversion works internally.
* A ghost character that rotates around a crypt in 3D space while floating up and down.
* A player name label in the GUI that follows the character's world position by converting it to screen coordinates.
* Demonstrates practical use of world-to-screen conversion for positioning UI elements relative to 3D objects.

Note: The reference Lua version does not preserve depth information and always returns `z = 0` to keep the code simpler.

```lua
--- Converts a world position to screen coordinates.
-- This function transforms a 3D world position to 2D screen coordinates using the camera's
-- view and projection matrices. The resulting coordinates are in screen space where (0,0)
-- is the bottom-left corner of the screen.
--
-- @param world_position vector3 The world position to convert.
-- @param camera_url url|string The camera component URL to use for the transformation.
-- @return number screen_x The X coordinate in screen space.
-- @return number screen_y The Y coordinate in screen space.
-- @return number screen_z Always returns 0 (depth information is not preserved).
local function world_to_screen(world_position, camera_url)
    local proj = camera.get_projection(camera_url)
    local view = camera.get_view(camera_url)

    local view_proj = proj * view
    local scr_coord = view_proj * vmath.vector4(world_position.x, world_position.y, world_position.z, 1)
    local w, h = window.get_size()
    scr_coord.x = (scr_coord.x / scr_coord.w + 1) * 0.5 * w
    scr_coord.y = (scr_coord.y / scr_coord.w + 1) * 0.5 * h

    return vmath.vector3(scr_coord.x, scr_coord.y, 0)
end
```
