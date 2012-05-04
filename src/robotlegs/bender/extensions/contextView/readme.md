# ContextView

The Context View Extension adds a configuration processor to the context that consumes a DisplayObjectContainer and maps it into the context. Many extensions require a DisplayObjectContainer to be present in order to function correctly.

## Installation

### During Context Construction

    _context = new Context()
        .extend(ContextViewExtension)
        .configure(this);

Note: The extension must be installed before a DisplayObjectContainer is provided or the DisplayObjectContainer will not be processed.

In the example above we provide the instance "this" to use as the Context View. We assume that "this" is a valid DisplayObjectContainer.
