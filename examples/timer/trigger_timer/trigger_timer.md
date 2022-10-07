---
title: Trigger timer example
brief: This example shows how to create timer that triggers counting every 1s and can be triggered manually and asynchronously as a reaction to user input.
scripts: trigger_timer.gui_script
---

The example shows how to use Defold built-in timer and trigger it asynchronously and uses two indicators:

1. A counter text increased every 1s created using a text node.
2. A text node with information displayed.

The timer triggers update of the counter every 1s.
Click anywhere to trigger the callback of the timer asynchronously.

![trigger_timer](trigger_timer.png)
