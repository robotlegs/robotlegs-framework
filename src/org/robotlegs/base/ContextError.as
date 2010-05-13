/*
 * Copyright (c) 2009 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.base
{
	
	/**
	 * A framework Error implementation
	 */
	public class ContextError extends Error
	{
		public static const E_COMMANDMAP_NOIMPL:String = 'Command Class does not implement an execute() method';
		public static const E_COMMANDMAP_OVR:String = 'Cannot overwrite map';
		
		public static const E_MEDIATORMAP_NOIMPL:String = 'Mediator Class does not implement IMediator';
		public static const E_MEDIATORMAP_OVR:String = 'Mediator Class has already been mapped to a View Class in this context';
		
		public static const E_EVENTMAP_NOSNOOPING:String = 'Listening to the context eventDispatcher is not enabled for this EventMap';
		
		public static const E_CONTEXT_INJECTOR:String = 'The ContextBase does not specify a concrete IInjector. Please override the injector getter in your concrete or abstract Context.';
		public static const E_CONTEXT_REFLECTOR:String = 'The ContextBase does not specify a concrete IReflector. Please override the reflector getter in your concrete or abstract Context.';
		
		public function ContextError(message:String = "", id:int = 0)
		{
			super(message, id);
		}
	}
}