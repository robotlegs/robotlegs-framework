# Object Processor

## Overview

An object processor enables asynchronous handling of interesting objects.

## Basic Usage

    const processor:IObjectProcessor = new ObjectProcessor();

    processor.addObjectHandler(instanceOf(ISomeType), function(object:ISomeType):void {
    	trace(object);
    });

    processor.addObject(new SomeType());

Note: The handler does *not* have to be an anonymous function, it can be an instance method.

## Object Matchers

Object matching is performed by [Hamcrest-as3][https://github.com/drewbourne/hamcrest-as3/wiki]

## Object Handlers

Object handling follows the framework asynchronous conventions. See:

+ core.async.readme
+ core.messaging.readme

## Async Handling

    const processor:IObjectProcessor = new ObjectProcessor();

    processor.addObjectHandler(
	    instanceOf(ISomeType),
    	function(object:ISomeType, callback:Function):void {
    		trace(object);
    		setTimeout(callback, 1000);
    	});
    
    processor.addObject(
	    new SomeType(),
	    function(error:Object):void {
	    	trace('Processing complete ', error);
	    });

Note: The processor above is stored as a local variable and thus may be garbage collected before processing completes. Normally this is not an issue however as the processor would be an instance variable and not a local variable.
