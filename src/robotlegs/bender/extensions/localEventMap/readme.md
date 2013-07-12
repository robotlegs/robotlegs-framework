# Event Map Extension

## Overview

An Event Map allows for mapping event listeners to a specific Event Dispatcher instance and provides some convenience methods not available with ordinary Event Dispatchers.

## Basic Usage

```as3
eventMap.mapListener(eventDispatcher, FooEvent.Foo, listener);
```

The Event Map keeps a list of listeners for easy removal.

## Unmapping all listeners

```as3
eventMap.unmapListeners();
```

Removes all listeners registered through `mapListener`.

## Unmapping a specific listener

```as3
eventMap.unmapListener(eventDispatcher, FooEvent.FOO, listener);

## Suspending and resuming event listening

The Event Map provides methods to suspend and resume event listening.

```as3
eventMap.mapListener(eventDispatcher, FooEvent.Foo, listener);
eventDispatcher.dispatchEvent(FooEvent.FOO); //listener is called

eventMap.suspend();
eventDispatcher.dispatchEvent(FooEvent.FOO); //listener is not called

eventMap.resume();
eventDispatcher.dispatchEvent(FooEvent.FOO); //listener is called again
```

## Strong typing events

Optionally you can register listeners to a concrete event class. This ensures that the listener will only be called if the event is an instance of a specific event class.

```as3
//registers the listener to the concrete FooEvent class
eventMap.mapListener(eventDispatcher, FooEvent.FOO, listener, FooEvent);

//the listener will not be called, since the event is an instance of Event not FooEvent
eventDispatcher.dispatchEvent(new Event(FooEvent.FOO)); 
```

## Extension Installation

```as3
_context = new Context()
    .install(LocalEventMapExtension);
```


## Extension Usage

An instance of IEventDispatcher is mapped into the context during extension installation. This instance can be injected into clients.

```as3
[Inject]
public var eventDispatcher:IEventDispatcher;
```
