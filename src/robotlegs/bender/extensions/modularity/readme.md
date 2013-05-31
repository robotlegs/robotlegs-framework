# Modularity Extension

## Overview

The modularity extensions wires contexts into a hierarchy based on the context view.

## Requirements

This extension requires the following extensions:

+ ContextViewExtension

## Extension Installation

```as3
_context = new Context()
    .install(ContextViewExtension, ModularityExtension)
    .configure(new ContextView(this));
```

In the example above we provide the instance "this" to use as the Context View. We assume that "this" is a valid DisplayObjectContainer.

By default the extension will be configured to inherit dependencies from parent contexts and expose dependencies to child contexts. You can change this by supplying parameters to the extension during installation:

```as3
_context = new Context()
    .install(ContextViewExtension)
    .install(new ModularityExtension(true, false))
    .configure(new ContextView(this));
```

The example context above inherits dependencies from parent contexts but does not expose its own dependencies to child contexts. However, child contexts may still inherit dependencies from this context's parents.

