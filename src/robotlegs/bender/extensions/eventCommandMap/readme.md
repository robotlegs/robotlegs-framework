# Event Command Map

## Overview

An Event Command Map executes commands in response to events on a given Event Dispatcher.

## Basic Usage

    eventCommandMap
        .map(SignOutEvent.SIGN_OUT, SignOutEvent)
        .toCommand(SignOutCommand);
    
    eventDispatcher.dispatchEvent(new SignOutEvent(SignOutEvent.SIGN_OUT));

Note: for a less verbose and more performant command mechanism see the MessageCommandMap extension.

## Mapping 'once' commands

If you know that you only want your command to fire once, and then be automatically unmapped:

	eventCommandMap
        .map(SignOutEvent.SIGN_OUT, SignOutEvent)
        .toCommand(SignOutCommand)
		.once();

## Mapping guards and hooks

You can optionally add guards and hooks:

	eventCommandMap
        .map(SignOutEvent.SIGN_OUT, SignOutEvent)
        .toCommand(SignOutCommand)
		.withGuards(NotOnTuesdays)
		.withHooks(UpdateLog);
	
Guards and hooks can be passed as arrays or just a list of classes.	

Guards will be injected with the event that fired, and hooks can be injected with both the event and the command (these injections are then cleaned up so that events and commands are not generally available for injection).

For more information on guards and hooks check out: 

1. robotlegs.bender.framework.readme-guards
2. robotlegs.bender.framework.readme-hooks

## Note: strictly one mapping per-event-per-command

You can only make one mapping per event-command pair. You should do your complete mapping in one chain, or keep a reference to the part of the chain where you need to stop. (At a minimum this should be to the `ICommandMapping` returned from `toCommand` as calling `toCommand` a second time will lock the mapping).

So - the following will explode:

	eventCommandMap.map(SomeEvent.STARTED).toCommand(SomeCommand);
	eventCommandMap.map(SomeEvent.STARTED).toCommand(SomeCommand).once();
	
If your mappings are completely identical, no error will be thrown. If the mappings differ in guards, hooks or the use of `once`, an error will be thrown as soon as possible. In the case that you add a guard or hook that wasn't previously present, the error will be synchronous. In the case that you miss out a guard or hook that was previously present, the error will be thrown the first time the mapping is next used.

# Event Command Map Extension

## Requirements

This extension requires the following extensions:

+ CommandMapExtension
+ EventDispatcherExtension

## Extension Installation

    _context = new Context().extend(
    	CommandCenterExtension,
    	EventDispatcherExtension,
	    EventCommandMapExtension);

Or, assuming that the EventDispatcher and CommandCenter extensions have already been installed:

	_context.extend(EventCommandMapExtension);

## Extension Usage

An instance of IEventCommandMap is mapped into the context during extension installation. This instance can be injected into clients and used as below.

	[Inject]
	public var eventCommandMap:IEventCommandMap;

