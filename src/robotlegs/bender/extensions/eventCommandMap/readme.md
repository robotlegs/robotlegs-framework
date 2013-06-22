# Event Command Map

## Overview

An Event Command Map executes commands in response to events on a given Event Dispatcher.

## Basic Usage

```as3
eventCommandMap
    .map(SignOutEvent.SIGN_OUT)
    .toCommand(SignOutCommand);

eventDispatcher.dispatchEvent(new SignOutEvent(SignOutEvent.SIGN_OUT));
```

## Strong typing events

Optionally you can map commands to a concrete event class. This ensures that the command will only be executed if the event instance is of a specific event class.

```as3
eventCommandMap
    .map(FooEvent.FOO, FooEvent) //mapping the command to the concrete FooEvent class
    .toCommand(FooCommand);

//the command will NOT be executed, since the event instance is of type Event
eventDispatcher.dispatchEvent(new Event(FooEvent.FOO)); 
```

## Event instance access inside commands

Commands are automatically injected with the event instance that triggered them, resolved to the type used for the mapping.

### Concrete event types

```as3
eventCommandMap
    .map(SignOutEvent.SIGN_OUT, SignOutEvent) //the second parameter defines the type of event instance injection
    .toCommand(SignOutCommand);
```
```as3
//SignOutCommand
[Inject]
public var event: SignOutEvent; //as mapped

public function execute():void{
    //do something useful with event
}
```

### Abstract event types

```as3
eventCommandMap
    .map(SignOutEvent.SIGN_OUT, Event) //the second parameter defines the type of event instance injection
    .toCommand(SignOutCommand);
```
```as3
//SignOutCommand
[Inject]
public var event: Event; //as mapped

public function execute():void{
    //do something useful with event
}
```

### Note: this deviates from Robotlegs v1 functionality

In Robotlegs v1 an event instance was automatically mapped both to the concrete event type and the abstract `Event` type.

## Mapping 'once' commands

If you know that you only want your command to fire once, and then be automatically unmapped:

```as3
eventCommandMap
    .map(SignOutEvent.SIGN_OUT, SignOutEvent)
    .toCommand(SignOutCommand)
	.once();
```

## Mapping guards and hooks

You can optionally add guards and hooks:

```as3
eventCommandMap
    .map(SignOutEvent.SIGN_OUT, SignOutEvent)
    .toCommand(SignOutCommand)
	.withGuards(NotOnTuesdays)
	.withHooks(UpdateLog);
```

Guards and hooks can be passed as lists of classes, objects or function references.

Guards will be injected with the event that fired, and hooks can be injected with both the event and the command (these injections are then cleaned up so that events and commands are not generally available for injection).

For more information on guards and hooks check out: 

1. robotlegs.bender.framework.readme-guards
2. robotlegs.bender.framework.readme-hooks

## Note: strictly one mapping per-event-per-command

You can only make one mapping per event-command pair. You should do your complete mapping in one chain.

So - the following will issue a warning:

```as3
eventCommandMap.map(SomeEvent.STARTED).toCommand(SomeCommand);
eventCommandMap.map(SomeEvent.STARTED).toCommand(SomeCommand); // warning
```

If you intend to change a mapping you should unmap it first.

# Event Command Map Extension

## Requirements

This extension requires the following extensions:

+ EventDispatcherExtension

## Extension Installation

```as3
_context = new Context().install(
    EventDispatcherExtension,
    EventCommandMapExtension);
```

Or, assuming that the EventDispatcherExtension has already been installed:

```as3
_context.install(EventCommandMapExtension);
```

## Extension Usage

An instance of IEventCommandMap is mapped into the context during extension installation. This instance can be injected into clients and used as below.

```as3
[Inject]
public var eventCommandMap:IEventCommandMap;
```
