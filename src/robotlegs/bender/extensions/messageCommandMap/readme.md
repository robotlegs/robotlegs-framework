# Message Command Map

## Overview

A Message Command Map executes commands in response to messages on a given Message Dispatcher.

## Basic Usage

    messageCommandMap
        .map(SignOutMessage)
        .toCommand(SignOutCommand);
    
    messageDispatcher.dispatchMessage(SignOutMessage);

# Message Command Map Extension

## Requirements

This extension requires the following extensions:

+ CommandMapExtension
+ MessageDispatcherExtension

## Extension Installation

### During Context Construction

    _context = new Context().extend(
    	CommandMapExtension,
    	MessageDispatcherExtension,
	    MessageCommandMapExtension);

### At Runtime

Assuming that the MessageDispatcher and CommandMap extensions have already been installed:

	_context.extend(MessageCommandMapExtension);

## Extension Usage

An instance of IMessageCommandMap is mapped into the context during extension installation. This instance can be injected into clients and used as above.

	[Inject]
    public var messageCommandMap:IMessageCommandMap;

