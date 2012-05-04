# CommandMap

The Command Map Extension is the basis for command map based extensions such as the Event Command Map and the Message Command Map.

It is not intended to be used directly.

## Installation

### During Context Construction

    _context = new Context()
        .extend(CommandMapExtension);

### At Runtime

	_context.extend(CommandMapExtension);
