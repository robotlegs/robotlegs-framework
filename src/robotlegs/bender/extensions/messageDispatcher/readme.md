# Message Dispatcher Extension

## Overview

The message dispatcher extension simply maps a shared message dispatcher into a context. The extension is required by many message driven extensions.

## Extension Installation

    _context = new Context()
        .extend(MessageDispatcherExtension);

You can provide the dispatcher instance you wish to use manually if you so desire:

    _context = new Context()
        .extend(new MessageDispatcherExtension(dispatcher));

## Extension Usage

An instance of IMessageDispatcher is mapped into the context during extension installation. This instance can be injected into clients.

	[Inject]
    public var messageDispatcher:IMessageDispatcher;
