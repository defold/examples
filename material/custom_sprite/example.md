---
name: CustomSprite
tags: material
title: Custom Sprite
brief: This example demonstrates a simple way to create and apply a custom sprite shader for changing colors and customizing an outline.
scripts: set_color.script, recolor.fp, recolor.vp
---

If your game requires a sprite that can be recolored and reused, a custom shader will be needed. Your sprite's artwork can be composed in such a way that will help achieve things you may want to do. For example an outline around your sprite that can be turned off/on and color changed. When creating your artwork if your sprite's green-channel is shifted slightly below 1.0 and you add an outline around your sprite with full green color equal to 1.0 then in the shader you can manage the green channel values that match 1.0 and change the color or completely hide these values thus removing the outline altogether. Recoloring sprites to be used throughout a game is pretty common. One way to achieve re-coloring with a range of values instead of a single color is to de-saturate a part of the sprite you want to recolor. When you de-saturate an image it will even out the red, green and blue channel values to a grey-scale. You can then check in the shader for these grey-scale values and change the colors. To check for these values you can add 2 or 3 channels together as a float value and then with another float multiply a single channel by 2 or 3, we then compare these values when valid use a new color.

In the example the custom sprite material has 2 vertex attributes each is a vector 4 of float values. The values are used for coloring the fluid and the outline from a script to the shader. The script has a function for creating a random color and also sets the color vertex properties