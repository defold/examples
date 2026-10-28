---
title: Handle Spine IK constraints
brief: Learn how to control Spine IK constraints by assigning a game object as the IK target.
author_ids:
  - evgenii-starostin
scripts: area.script, cursor.script, manipulator.script
thumbnail: thumbnail.webp
tags: animation
---
This example demonstrates how to control Spine Inverse Kinematics (IK) constraints in Defold by assigning a game object as the IK target.

Move the mouse or touch in the active area (white rectangle in the background) to move the robot's arm with IK constraints.


## Project Structure
```
- root
  - active_area.go
    - collisionobject
    - area.script
    - sprite
  - cursor.go
    - collisionobject
    - cursor.script
  - manipulator.script
  - spinemodel
```

## How It Works
The `cursor.go` game object is controlled by the user and has a collision object configured as a trigger.
When the cursor overlaps with the trigger in `active_area.go`, it sends a message to `manipulator.script`.
The script uses the Defold Spine API to assign `cursor.go` as the target of an IK constraint with spine.set_ik_target(). 
When the target is no longer needed, spine.reset_ik_target() resets the constraint to its original target position.
