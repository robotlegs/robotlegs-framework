# ContextView Extension (Bundled with MVCS)

The Context View Extension adds a configuration processor to the context that consumes a ContextView object and maps the provided view as a DisplayObjectContainer into the context. Many extensions require a DisplayObjectContainer to be present in order to function correctly.

## Installation

### During Context Construction

```as3
_context = new Context()
    .install(ContextViewExtension)
    .configure(new ContextView(this));
```

Note: The ContextViewExtension must be installed before the ContextView is provided or it will not be processed.

In the example above we provide the instance "this" to use as the view. We assume that "this" is a valid DisplayObjectContainer.

# StageSync Extension (Bundled with MVCS)

The Stage Sync Extension waits for a ContextView to be added as a configuration, and initializes and destroys the context based on the contextView's stage presence.

```as3
_context = new Context()
    .install(ContextViewExtension, StageSyncExtension)
    .configure(new ContextView(this));
```

Due to the StageSyncExtension the context above will automatically initialize when the Context View lands on the stage.

## Manual Context Initialization

If you do not install the StageSync Extension or do not provide a Context View you must initialize the context manually:

```as3
_context = new Context()
    .install(MyCompanyBundle)
    .configure(MyAppConfig, SomeOtherConfig)
    .initialize();
```
