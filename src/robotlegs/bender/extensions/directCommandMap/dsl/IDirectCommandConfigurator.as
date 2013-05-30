//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.directCommandMap.dsl
{
	import robotlegs.bender.extensions.directCommandMap.api.IDirectCommandMapper;

	/**
	 * @private
	 */
	public interface IDirectCommandConfigurator extends IDirectCommandMapper
	{
		/**
		 * The "execute" method to invoke on the Command instance
		 * @param name Method name
		 * @return Self
		 */
		function withExecuteMethod(name:String):IDirectCommandConfigurator;

		/**
		 * Guards to check before allowing a command to execute
		 * @param guards Guards
		 * @return Self
		 */
		function withGuards(... guards):IDirectCommandConfigurator;

		/**
		 * Hooks to run before command execution
		 * @param hooks Hooks
		 * @return Self
		 */
		function withHooks(... hooks):IDirectCommandConfigurator;

		/**
		 * Should the payload values be injected into the command instance?
		 * @param value Toggle
		 * @return Self
		 */
		function withPayloadInjection(value:Boolean = true):IDirectCommandConfigurator;
	}
}
