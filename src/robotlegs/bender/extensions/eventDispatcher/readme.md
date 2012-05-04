# Event Dispatcher Extension

## Overview

The event dispatcher extension simply maps a shared event dispatcher into a context. The extension is required by many event driven extensions.

## Extension Installation

    _context = new Context()
        .extend(EventDispatcherExtension);

You can provide the dispatcher instance you wish to use manually if you so desire:

    _context = new Context()
        .extend(new EventDispatcherExtension(dispatcher));

## Extension Usage

An instance of IEventDispatcher is mapped into the context during extension installation. This instance can be injected into clients.

	[Inject]
    public var eventDispatcher:IEventDispatcher;
