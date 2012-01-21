# Event Command Map

The Event Command Map executes commands in response to events on a given Event Dispatcher:

    eventCommandMap
        .map(SignOutEvent.SIGN_OUT, SignOutEvent)
        .toCommand(SignOutCommand);
    
    eventDispatcher.dispatchEvent(new SignOutEvent(SignOutEvent.SIGN_OUT));

Note: for a less verbose command mechanism see the Message Command Map extension.