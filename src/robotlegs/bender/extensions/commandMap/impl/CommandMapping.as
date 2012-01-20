//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandMap.impl
{
	import robotlegs.bender.extensions.commandMap.api.ICommandMapping;
	import robotlegs.bender.extensions.commandMap.dsl.ICommandMappingConfig;

	public class CommandMapping implements ICommandMapping, ICommandMappingConfig
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _commandClass:Class;

		public function get commandClass():Class
		{
			return _commandClass;
		}

		private var _guards:Array = [];

		public function get guards():Array
		{
			return _guards;
		}

		private var _hooks:Array = [];

		public function get hooks():Array
		{
			return _hooks;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function CommandMapping(commandClass:Class)
		{
			_commandClass = commandClass;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function withGuards(... guards):ICommandMappingConfig
		{
			_guards = _guards.concat.apply(null, guards);
			return this;
		}

		public function withHooks(... hooks):ICommandMappingConfig
		{
			_hooks = _hooks.concat.apply(null, hooks);
			return this;
		}
	}
}
