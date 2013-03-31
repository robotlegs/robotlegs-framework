//------------------------------------------------------------------------------
//  Copyright (c) 2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.eventCommandMap.api
{
	public interface IEventCommandConfigurator
	{
		/**
		 * The "execute" method to invoke on the Command instance
		 * @param name Method name
		 * @return Self
		 */
		function withExecuteMethod(name:String):IEventCommandConfigurator;

		/**
		 * Guards to check before allowing a command to execute
		 * @param guards Guards
		 * @return Self
		 */
		function withGuards(... guards):IEventCommandConfigurator;

		/**
		 * Hooks to run before command execution
		 * @param hooks Hooks
		 * @return Self
		 */
		function withHooks(... hooks):IEventCommandConfigurator;

		/**
		 * Should this command only run once?
		 * @param value Toggle
		 * @return Self
		 */
		function once(value:Boolean = true):IEventCommandConfigurator;

		/**
		 * Priority
		 * @param value Toggle
		 * @return Self
		 */
		function withPriority(value:int):IEventCommandConfigurator;
	}
}
