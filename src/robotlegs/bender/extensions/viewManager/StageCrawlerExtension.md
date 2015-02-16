# Stage Crawler Extension

## Overview

The Stage Crawler Extension scans and handles all views in the containers or contextview after context initialization.
This enables us to handle the views that might already be on the stage before initialization which would otherwise not be processed (or mediated).

It is reliant on either a IViewManager or a ContextView upon initializtion.

## How to Install

This extension is already installed in the MVCS bundle, but if you're not using that:

```as3
context.install(StageCrawlerExtension);
```

Then after the context has been initialized, the containers will be scanned and then the views will be processed.