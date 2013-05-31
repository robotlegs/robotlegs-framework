# Async

To deal with asynchronous processes in the framework we must establish some conventions.

# Handlers and Callbacks

Handlers and callbacks are conventions used by low level components such as the Message Dispatcher.

## Handlers

A handler *must* have one of the following signatures:

```as3
function handler():void;
function handler(message:Object):void;
function handler(message:Object, callback:Function);
```

Note: the arguments can be typed where and when it makes sense to do so.

The first two forms allow for basic observing. The third form allows for asynchronous interaction.

By consuming a callback a handler is given the opportunity to suspend or terminate a process:

```as3
function handler(message:Object, callback:Function):void {
  setTimeout(callback, 100);
}
```

A handler can terminate a process by sending an error to the callback:

```as3
function handler(message:Object, callback:Function):void {
  if (!message) {
    callback(new Error("There was no message. Something went very wrong."));
  } else {
    callback();
  }
}
```

Note: A handler *must* eventually call the callback or the processes will never complete.

A handler should only call the callback once. The following is *naughty*:

```as3
function handler(message:Object, callback:Function):void {
  if (!message) {
    callback(new Error("There was no message. Something went very wrong."));
  }
  callback();
}
```

The code above will call the callback twice when the message is falsey. Libraries will usually guard against this sort of thing, but it's best not to tempt fate in this case.

## Callbacks

A callback *must* have one of the following signatures:

```as3
function callback():void;
function callback(error:Object):void;
function callback(error:Object, message:Object):void;
```

Note: the arguments can be typed where and when it makes sense to do so.

A callback is usually supplied to some asynchronous method:

```as3
loadUser("borris", function():void {
  trace("I think we have a borris.");
});
```

A callback should deal with errors:

```as3
loadUser("borris", function(error:Error):void {
  if (error) {
    throw error;
  } else {
    trace("I'm certain we have a borris.");
  }
});
```

A callback that doesn't accept an error will still be called in the case of an error:

```as3
doSomethingImportant(function():void {
  trace("I'm not sure if that worked, but I know we're done.");
});
```

For this reason callbacks should *always* deal with errors (preferably before doing anything else).

## safelyCallBack()

Helper function to simplify calling user facing callbacks:

    safelyCallBack(callback, error, message);

Note: the helper will *not* protect against null callbacks. You *must* do that yourself:

    callback && safelyCallBack(callback, error, message);

This prevents the overhead of calling safelyCallBack() when there is no callback to call. Likewise it reduces the overhead of a null check in safelyCallBack().
