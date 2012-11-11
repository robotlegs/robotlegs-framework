//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMappingConfig;

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

		private var _fireOnce:Boolean;

		public function get fireOnce():Boolean
		{
			return _fireOnce;
		}

		private var _next:ICommandMapping;

		public function get next():ICommandMapping
		{
			return _next;
		}

		public function set next(value:ICommandMapping):void
		{
			_next = value;
		}

		private var _previous:ICommandMapping;

		public function get previous():ICommandMapping
		{
			return _previous;
		}

		public function set previous(value:ICommandMapping):void
		{
			_previous = value;
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

		public function once(value:Boolean = true):ICommandMappingConfig
		{
			_fireOnce = value;
			return this;
		}

		public function toString():String
		{
			return 'Command ' + _commandClass;
		}
	}
}
