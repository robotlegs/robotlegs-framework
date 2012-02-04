# StateMachine

A simple state machine (not a finite state machine).

## Overview

A state is registered with a series of steps. These steps are handled in sequence when the state machine changes state. Step handlers can be asynchronous. For more information on asynchronous handling see:

+ core.async.readme
+ core.messaging.readme

## Basic Usage

    const machine:IStateMachine = new StateMachine();

    machine.addState("suspend", ["preSuspend", "postSuspend"]);
    
    machine.addStateHandler(
	    "preSuspend",
	    function(step:String, callback:Function):void {
    		trace("handling ", step);
    		setTimeout(callback, 250);
    	});
    
    machine.addStateHandler("postSuspend", function():void {
    	trace("handling postSuspend");
    });
    
    machine.setCurrentState("suspend");

Note: State and step names must be unique for a given state machine. You can *not* register a state or step name that has already been registered with a given machine.
