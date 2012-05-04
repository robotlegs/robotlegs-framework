# Event Command Map

## Overview

An Event Command Map executes commands in response to events on a given Event Dispatcher.

## Basic Usage

    eventCommandMap
        .map(SignOutEvent.SIGN_OUT, SignOutEvent)
        .toCommand(SignOutCommand);
    
    eventDispatcher.dispatchEvent(new SignOutEvent(SignOutEvent.SIGN_OUT));

Note: for a less verbose and more performant command mechanism see the MessageCommandMap extension.

# Event Command Map Extension

## Requirements

This extension requires the following extensions:

+ CommandMapExtension
+ EventDispatcherExtension

## Extension Installation

    _context = new Context().extend(
    	CommandMapExtension,
    	EventDispatcherExtension,
	    EventCommandMapExtension);

Or, assuming that the EventDispatcher and CommandMap extensions have already been installed:

	_context.extend(EventCommandMapExtension);

## Extension Usage

An instance of IEventCommandMap is mapped into the context during extension installation. This instance can be injected into clients and used as above.

	[Inject]
	public var eventCommandMap:IEventCommandMap;

