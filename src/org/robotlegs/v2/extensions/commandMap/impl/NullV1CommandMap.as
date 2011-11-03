//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.commandMap.impl
{
	import org.robotlegs.core.ICommandMap;

	public class NullV1CommandMap implements ICommandMap
	{
		protected static const UNSUPPORTED_V1_FEATURE:String = "While version 1 Robotlegs Commands are supported in the version 2 CommandMap, the version 1 ICommandMap injected in to them is a null implementation and cannot be used. If you need to use a mediator map in your mediator, inject the version 2 ICommandMap.";
		
		public function detain(command:Object):void
		{
			throwNullImplementationError();
		}

		public function release(command:Object):void
		{
			throwNullImplementationError();
		}

		public function execute(commandClass:Class, payload:Object = null, payloadClass:Class = null, named:String = ''):void
		{
			throwNullImplementationError();
		}

		public function mapEvent(eventType:String, commandClass:Class, eventClass:Class = null, oneshot:Boolean = false):void
		{
			throwNullImplementationError();
		}

		public function unmapEvent(eventType:String, commandClass:Class, eventClass:Class = null):void
		{
			throwNullImplementationError();
		}

		public function unmapEvents():void
		{
			throwNullImplementationError();
		}

		public function hasEventCommand(eventType:String, commandClass:Class, eventClass:Class = null):Boolean
		{
			throwNullImplementationError();
			return false;
		}
		
		protected function throwNullImplementationError():void
		{
			throw new Error(UNSUPPORTED_V1_FEATURE);
		}
	}
}
