/*
 * Copyright (c) 2009 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.core
{
	
	/**
	 * The Robotlegs CommandMap contract
	 */
	public interface ICommandMap
	{
		/**
		 * Detain a Command instance
		 * 
		 * @param command The Command instance to detain
		 */		
		function detain(command:Object):void;
		
		/**
		 * Release a Command instance
		 * 
		 * @param command The Command instance to release for garbage collection
		 */		
		function release(command:Object):void;
		
		/**
		 * Execute a Command with an optional payload
		 * 
		 * <p>The <code>commandClass</code> must implement an execute() method</p>
		 * 
		 * @param commandClass The Class to instantiate - must have an execute() method
		 * @param payload An optional payload
		 * @param payloadClass  An optional class to inject the payload as
		 * @param named An optional name for the payload injection
		 * 
		 * @throws org.robotlegs.base::ContextError
		 */		
		function execute(commandClass:Class, payload:Object = null, payloadClass:Class = null, named:String = ''):void;
		
		/**
		 * Map a Class to an Event type
		 * 
		 * <p>The <code>commandClass</code> must implement an execute() method</p>
		 * 
		 * @param eventType The Event type to listen for
		 * @param commandClass The Class to instantiate - must have an execute() method
		 * @param eventClass Optional Event class for a stronger mapping. Defaults to <code>flash.events.Event</code>. Your commandClass can optionally [Inject] a variable of this type to access the event that triggered the command.
		 * @param oneshot Unmap the Class after execution?
		 * 
		 * @throws org.robotlegs.base::ContextError
		 */
		function mapEvent(eventType:String, commandClass:Class, eventClass:Class = null, oneshot:Boolean = false):void;
		
		/**
		 * Unmap a Class to Event type mapping
		 *
		 * @param eventType The Event type
		 * @param commandClass The Class to unmap
		 * @param eventClass Optional Event class for a stronger mapping. Defaults to <code>flash.events.Event</code>.
		 */
		function unmapEvent(eventType:String, commandClass:Class, eventClass:Class = null):void;
		
		/**
		 * Removes all mappings made through <code>mapEvent</code>
		 */		
		function unmapEvents():void;
		
		/**
		 * Check if a Class has been mapped to an Event type
		 *
		 * @param eventType The Event type
		 * @param commandClass The Class
		 * @param eventClass Optional Event class for a stronger mapping. Defaults to <code>flash.events.Event</code>.
		 * @return Whether the Class is mapped to this Event type
		 */
		function hasEventCommand(eventType:String, commandClass:Class, eventClass:Class = null):Boolean;
	}
}
