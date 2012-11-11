# Message Command Map

## Overview

A Message Command Map executes commands in response to messages on a given Message Dispatcher.

## Basic Usage

    messageCommandMap
        .map(SignOutMessage)
        .toCommand(SignOutCommand);
    
    messageDispatcher.dispatchMessage(SignOutMessage);

## Mapping 'once' commands

If you know that you only want your command to fire once, and then be automatically unmapped:

	messageCommandMap
        .map(SignOutMessage)
        .toCommand(SignOutCommand)
		.once();

## Mapping guards and hooks

You can optionally add guards and hooks:

	messageCommandMap
        .map(SignOutMessage)
        .toCommand(SignOutCommand)
		.withGuards(NotOnTuesdays)
		.withHooks(UpdateLog);

Guards and hooks can be passed as arrays or just a list of classes.	

Guards will be injected with the message that fired, and hooks can be injected with both the event and the command (these injections are then cleaned up so that messages and commands are not generally available for injection).

For more information on guards and hooks check out: 

1. robotlegs.bender.framework.readme-guards
2. robotlegs.bender.framework.readme-hooks

## Note: strictly one mapping per-message-per-command

You can only make one mapping per message-command pair. You should do your complete mapping in one chain.

So - the following will issue a warning:

	messageCommandMap.map(SignOutMessage).toCommand(SomeCommand);
	messageCommandMap.map(SignOutMessage).toCommand(SomeCommand); // warning

If you intend to change a mapping you should unmap it first.

# Message Command Map Extension

## Requirements

This extension requires the following extensions:

+ CommandMapExtension
+ MessageDispatcherExtension

## Extension Installation

### During Context Construction

    _context = new Context().install(
    	CommandCenterExtension,
    	MessageDispatcherExtension,
	    MessageCommandMapExtension);

### At Runtime

Assuming that the MessageDispatcher and CommandCenter extensions have already been installed:

	_context.install(MessageCommandMapExtension);

## Extension Usage

An instance of IMessageCommandMap is mapped into the context during extension installation. This instance can be injected into clients and used as below.

	[Inject]
    public var messageCommandMap:IMessageCommandMap;

