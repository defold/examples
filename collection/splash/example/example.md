---
tags: collection
title: Splash
brief: This example shows how to use collection proxies to show a splash screen while loading a game menu.
scripts: controller.script
---

The setup consists of several collections and game objects.

![splash](splash.png)

splash.collection
: This is the bootstrap collection specified in `game.project`. Contains:
  - A *Script* that handles loading and unloading of collection proxies
  - Two *Collection proxies* referencing the splash screen and a menu collection.

![menu](menu.png)

menu.collection
: This collection contains a menu. Contains:
  - A *GUI* with some box and text nodes that acts as buttons.

![splashscreen](splashscreen.png)

splashscreen.collection
: Collections representing the splash screen.
