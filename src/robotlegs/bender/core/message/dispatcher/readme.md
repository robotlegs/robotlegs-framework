# Message Dispatcher

## Listeners listen, handlers handle

The Event Dispatcher give us a great way to observe objects, but the dispatch processes is synchronous and listeners do not have the opportunity to suspend or terminate the dispatch. That's completely fine when we're just watching.

A Message Dispatcher is like an Event Dispatcher, but the dispatch has the potential to be asynchronous and handlers have the opportunity to suspend or terminate the dispatch.

If an Event Dispatcher is a loudhailer, a Message Dispatcher is a circuit board [todo: find better thing].

## Important

Message Dispatchers do not replace Event Dispatchers in any way. They solve completely different problems. The differences are explored in greater detail below.

# Comparison

## Overview

Event Dispatchers dispatch "events" to "listeners". The dispatch is synchronous (blocking).

Message Dispatchers route "messages" through "handlers". The dispatch may be synchronous or asynchronous depending on the handlers.

    const user:User = new User("Sally");
    
    const asyncHandler:Function = function(user:User, callback:Function):void {
      trace('Just gonna chill for, like, 1000 milliseconds or something...');
      setTimeout(callback, 1000);
    };
    
    const syncHandler:Function = function(user:User):void {
      trace('Golly, I synchronously observed: ' + user);
    };
    
    messageDispatcher.addMessageHandler(user, asyncHandler);
    messageDispatcher.addMessageHandler(user, syncHandler);
    
    messageDispatcher.dispatchMessage(user, function():void {
      trace('Dispatch eventually completed');
    });

## Events & Messages

### Events (Event Dispatcher)

Events are objects of type Event:

    new Event("hello")
    new MouseEvent(MouseEvent.CLICK)

### Messages (Message Dispatcher)

Messages are objects of any type:

    "hello"
    new User()

## Listeners & Handlers

### Listeners (Event Dispatcher)

Listeners are functions that accept objects of type Event:

    function onHello(event:Event):void
    function onClick(event:MouseEvent):void

### Handlers (Message Dispatcher)

Handlers are functions that handle messages, optionally suspending, resuming or terminating the sequential dispatch.

    function handleGreeting(greeting:String):void
    function handleUser(user:User):void

A handler *must* have one of the following signatures:

    function():void
    function(message:Object):void
    function(message:Object, callback:Function):void

Handlers *can* accept typed messages:

    function handleGreeting(greeting:String):void
    function handleUser(user:User):void

Handlers that accepts callbacks have the potential to be asynchronous:

    function handleUser(user:User, callback:Function):void {
      setTimeout(callback, 1000);
    }

Asynchronous handlers can terminate the dispatch by sending an error to the callback:

    function handleUser(user:User, callback:Function):void {
      callback(new Error("something went wrong"));
    }

Note: The error object can be of any type although sending actual Error instances is highly recommended. The following is *not recommended*:

    function handleUser(user:User, callback:Function):void {
      callback("something went wrong");
    }

## Adding Listeners & Handlers

### Adding Listeners (Event Dispatcher)

Listeners are added to event dispatchers by string keys:

    eventDispatcher.addEventListener("hello", onHello)
    eventDispatcher.addEventListener(MouseEvent.CLICK, onClick)

### Adding Handlers (Message Dispatcher)

Handlers are added to message dispatchers with the message itself as the key:

    messageDispatcher.addMessageHandler("hello", handleGreeting)
    messageDispatcher.addMessageHandler(user, handleUser)

## Dispatching Events & Messages

### Dispatching an Event (Event Dispatcher)

Dispatching an event is synchronous (and immutable? write a test):

    eventDispatcher.dispatchEvent(new Event("hello"));
    // we can be sure that the dispatch has completed at this point

### Dispatching a Message (Message Dispatcher)

Dispatching a message may be asynchronous (non-blocking), but the dispatch is always run in series.

    messageDispatcher.dispatchMessage("hello");
    // we can not be sure that the dispatch has completed at this point

Note: Dispatch might sometimes be synchronous, depending on the handlers.

### Callbacks

Dispatch completion triggers a callback (optional):

    messageDispatcher.dispatchMessage("hello", function():void {
      // dispatch has completed
    });

A callback *must* have one of the following signatures:

    function callback():void;
    function callback(error:Object):void;

### Errors

An error returned from a handler is sent to the original callback:

    messageDispatcher.dispatchMessage(user, function(error:Object):void {
      if (error) {
        trace('dang, there was a problem: ' + error);
        throw error;
      } else {
        trace('Dispatch eventually completed');
      }
    });

Note: One should always accept and handle errors in a callback.

# Handler and Callback Quick Reference

## Valid Handler Signatures

    function():void
    function(message:Object):void
    function(message:Object, callback:Function):void

## Valid Callback Signatures

    function():void
    function(error:Object):void
    function(error:Object, message:Object):void

# Considerations

## Stack Depth

Sequential synchronous callbacks increase the stack depth. However, the stack depth should drop back as soon as an asynchronous handler is encountered.

## Asynchronous Error Handling

### The type of the error objects

### Uncaught Exceptions

todo: write tests for inspecting an Error passed back to callback.

## Adding a handler more than once

Currently: allowed. Handler will be called more than once.

todo: decide if allowed, justify

## Safety

todo: write safety tests

## Speed

Message Dispatcher performs roughly the same as an Event Dispatcher for non-callback handlers. Handlers that accept callbacks slow things down and increase the stack depth.

## Limitations

todo: stack depth maximums, stack overflow

# Background

The majority of the API is modelled on Event Dispatcher, but the callback style is inspired by work going on in other evented environments where control flow is an issue. See:

http://nodeguide.com/style.html#callbacks
https://github.com/caolan/async
http://en.wikipedia.org/wiki/Futures_and_promises
http://wiki.commonjs.org/wiki/Promises/A
http://taskjs.org/
http://api.jquery.com/category/deferred-object/
https://github.com/briancavalier/when.js

The Message Dispatcher provides a simple alternative to a full blown Deferred, Promise or Future implementation, but at the cost of flexibility: 

"Using a callback in a function is the poor man's version of Promises. You can't easily chain extra callbacks. However, it's cheaper, it doesn't require creating the extra promise objects and callback chain. Outward facing APIs should provide promises rather than callbacks. Internally the functions implemented with c++ just use a callback." see: http://groups.google.com/group/nodejs/msg/10ad8f49535910bf

# Dev Notes

todo: add thoughts and considerations for future.