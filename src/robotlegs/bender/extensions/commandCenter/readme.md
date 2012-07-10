# CommandCenter

This extension is used by command based extensions such as the Event Command Map and the Message Command Map.

It is not intended to be used directly. It is included in the MVCS Bundle.

## Installation

### During Context Construction

    _context = new Context()
        .extend(CommandCenterExtension);

### At Runtime

	_context.extend(CommandCenterExtension);
