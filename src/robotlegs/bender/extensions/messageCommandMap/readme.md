# Message Command Map

The Message Command Map executes commands in response to messages on a given Message Dispatcher:

    messageCommandMap
        .map(SignOutMessage)
        .toCommand(SignOutCommand);
    
    messageDispatcher.dispatchMessage(SignOutMessage);

