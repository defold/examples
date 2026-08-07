---
title: Infinite Scroll Animation
brief: Learn how to make infinite scroll for all objects on your level with only two scripts
author: Evgenii Starostin
scripts: scroll_item.script, scroll_controller.script
thumbnail: thumbnail.webp
tags: animation
---
This example demonstrates a reusable infinite scrolling system for Defold. The setup works with any type of game object and allows you to build multiple scrolling layers, making it useful for parallax backgrounds, decorations, or endlessly moving scenery.

The project uses assets from the [Shape Characters](https://kenney.nl/assets/shape-characters) by Kenney.


## Project Structure
The scene is built from several independent scrolling layers.

```
main.collection
├── floor.collection
├── background.collection
├── middle.collection
└── foreground.collection
```
Each layer is a collection containing:

a root game object with `scroll_controller.script`
one or more scrolling game objects
`scroll_item.script` attached to every scrolling object

Each layer can have its own speed, direction and scrolling bounds.

## Registering Objects
Every scrolling object contains a small helper script.

During initialization it registers itself with the layer controller by sending its game object id.
```lua
function init(self)
    msg.post("root#scroll_controller", "prop:register", {
        id = go.get_id()
    })
end
```
The controller collects all registered objects before starting the scrolling logic.

## Controller Properties
Each scrolling layer can be configured using script properties.
```lua
go.property("SPEED", 90)
go.property("DIRECTION", -1)
go.property("LEFT_BOUND", -1000)
go.property("RIGHT_BOUND", 1000)
go.property("COUNT_OBJECTS", 1)
```
| Property | Description |
| -------- | ------- |
| SPEED |	Scrolling speed in pixels per second. |
| DIRECTION	| Scroll direction (-1 for left, 1 for right). |
| LEFT_BOUND	| Position where objects wrap when scrolling left. |
| RIGHT_BOUND	| Position where objects wrap when scrolling right. |
| COUNT_OBJECTS	| Number of scrolling objects expected in the layer. |

Different collection instances can override these values to create parallax effects without changing any code.

## How It Works
Once all objects have registered, the controller:
- Reads the position of every object.
- Sorts them from left to right.
- Calculates the distance between each object and its neighbour.

Instead of using a fixed spacing value, the controller stores the original distance between neighbouring objects. This means the objects can be placed freely in the editor while preserving their layout during scrolling.

Every frame, all objects move by the same amount.

When the leftmost object reaches the left boundary, it is moved to the right side of the layer using the previously calculated spacing. The same logic can also be applied when scrolling in the opposite direction.

Because the original spacing is preserved, the scrolling loop appears seamless even when objects are unevenly distributed.

## Customizing
The system is designed to be reusable.

You can:
- Add or remove scrolling objects.
- Use sprites, animated game objects, labels, or any other game object.
- Create multiple scrolling layers with different speeds.
- Adjust the scrolling bounds for each layer.
- Reverse the scrolling direction.

No changes to the scripts are required when creating additional layers.

## Summary
By separating object registration from movement logic, the same scrolling system can be reused across many collections. Each layer manages its own objects independently, making it easy to build infinite scrolling scenes and parallax backgrounds while keeping the project structure simple