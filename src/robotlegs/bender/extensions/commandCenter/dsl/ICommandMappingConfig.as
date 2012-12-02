//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.dsl
{

	/**
	 * Configures a command mapping
	 */
	public interface ICommandMappingConfig
	{
		/**
		 * Guards to check before allowing a command to execute
		 * @param guards Guards
		 * @return Self
		 */
		function withGuards(... guards):ICommandMappingConfig;

		/**
		 * Hooks to run before command execution
		 * @param hooks Hooks
		 * @return Self
		 */
		function withHooks(... hooks):ICommandMappingConfig;

		/**
		 * Should this command only run once?
		 * @param value Toggle
		 * @return Self
		 */
		function once(value:Boolean = true):ICommandMappingConfig;
	}
}
