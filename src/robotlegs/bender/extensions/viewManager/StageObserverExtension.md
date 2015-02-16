# Stage Observer Extension

## Overview

The Stage Observer Extension adds a single instance. Which listens for everything that is Event.ADDED_TO_STAGE on all root containers in the Container Registry, and then processes the view for you.

It will listen for removal and new root containers and adjust it's listeners appropriatley.

The Stage Observer has a static instance stored in the extension but will destory/cleanup when all context's have been destroyed.

## How to Install

This extension is already installed in the MVCS bundle, but if you're not using that:

```as3
context.install(StageObserverExtension);
```