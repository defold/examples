---
title: Rotate 3D object towards the mouse cursor
brief: Learn how to rotate a 3D object towards the mouse cursor.
author_ids:
  - evgenii-starostin
scripts: turret_controller.script, camera_controller.script
thumbnail: thumbnail.webp
tags: movement
---
This example demonstrates how to rotate a 3D object towards the mouse cursor.

## Project Structure
```
- camera.go
  - camera
  - camera_controller.script
  floor.go
  - floor
  - floor_uv_scale.script
  root.go
    - turret.go
      - turret
      - turret_controller.script
    - base
```

## How It Works
First, the script that controls the rotation needs a reference to the active camera. This is done by sending a message in `init`:

```lua
	msg.post("/turret#turret_controller", "register_camera", {
		url = msg.url("#camera")
	})
```

In turret_controller.script we use the camera to build a picking ray - a line that starts at the camera and goes through the cursor position in the world:

```lua
-- z = 0 -> near plane, z = 1 -> far plane (normalized depth)
local p0 = camera.screen_to_world(
	vmath.vector3(self.mouse_x, self.mouse_y, 0),
	self.camera_url
)

local p1 = camera.screen_to_world(
	vmath.vector3(self.mouse_x, self.mouse_y, 1),
	self.camera_url
)

local ray = p1 - p0
```

Then we intersect this ray with the horizontal plane at the turret's height (y = gun_pos.y):
```lua
go.update_world_transform()
local gun_pos = go.get_world_position()

-- avoid division by zero when the ray is parallel to the plane
if math.abs(ray.y) < 0.00001 then
	return
end

local t = (gun_pos.y - p0.y) / ray.y
local target = p0 + ray * t
```

Finally, we compute the yaw angle from the turret to the target and rotate the object around the Y axis. atan2(dx, dz) assumes the model faces +Z at angle 0:
```lua
local dx = target.x - gun_pos.x
local dz = target.z - gun_pos.z

if math.abs(dx) + math.abs(dz) < 0.00001 then
	return
end

local angle = math.atan2(dx, dz)

go.set_rotation(
	vmath.quat_rotation_y(angle)
)
```