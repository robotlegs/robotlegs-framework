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

You can only make one mapping per message-command pair. You should do your complete mapping in one chain, or keep a reference to the part of the chain where you need to stop. (At a minimum this should be to the `ICommandMapping` returned from `toCommand` as calling `toCommand` a second time will lock the mapping).

So - the following will explode:

	messageCommandMap.map(SignOutMessage).toCommand(SomeCommand);
	messageCommandMap.map(SignOutMessage).toCommand(SomeCommand).once();

If your mappings are completely identical, no error will be thrown. If the mappings differ in guards, hooks or the use of `once`, an error will be thrown as soon as possible. In the case that you add a guard or hook that wasn't previously present, the error will be synchronous. In the case that you miss out a guard or hook that was previously present, the error will be thrown the first time the mapping is next used.

# Message Command Map Extension

## Requirements

This extension requires the following extensions:

+ CommandMapExtension
+ MessageDispatcherExtension

## Extension Installation

### During Context Construction

    _context = new Context().extend(
    	CommandCenterExtension,
    	MessageDispatcherExtension,
	    MessageCommandMapExtension);

### At Runtime

Assuming that the MessageDispatcher and CommandCenter extensions have already been installed:

	_context.extend(MessageCommandMapExtension);

## Extension Usage

An instance of IMessageCommandMap is mapped into the context during extension installation. This instance can be injected into clients and used as below.

	[Inject]
    public var messageCommandMap:IMessageCommandMap;

