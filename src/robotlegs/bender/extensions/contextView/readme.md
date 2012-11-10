# ContextView

The Context View Extension adds a configuration processor to the context that consumes a ContextView object and maps the provided view as a DisplayObjectContainer into the context. Many extensions require a DisplayObjectContainer to be present in order to function correctly.

## Installation

### During Context Construction

    _context = new Context()
        .install(ContextViewExtension)
        .configure(new ContextView(this));

Note: The extension must be installed before the ContextView is provided or it will not be processed.

In the example above we provide the instance "this" to use as the view. We assume that "this" is a valid DisplayObjectContainer.
