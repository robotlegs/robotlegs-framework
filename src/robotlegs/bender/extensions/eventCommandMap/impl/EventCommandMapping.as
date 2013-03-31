//------------------------------------------------------------------------------
//  Copyright (c) 2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.eventCommandMap.impl
{
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandConfigurator;

	public class EventCommandMapping implements ICommandMapping, IEventCommandConfigurator
	{
		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _commandClass:Class;

		/**
		 * @inheritDoc
		 */
		public function get commandClass():Class
		{
			return _commandClass;
		}

		private var _executeMethod:String = "execute";

		/**
		 * @inheritDoc
		 */
		public function get executeMethod():String
		{
			return _executeMethod;
		}

		private var _guards:Array = [];

		/**
		 * @inheritDoc
		 */
		public function get guards():Array
		{
			return _guards;
		}

		private var _hooks:Array = [];

		/**
		 * @inheritDoc
		 */
		public function get hooks():Array
		{
			return _hooks;
		}

		private var _fireOnce:Boolean;

		/**
		 * @inheritDoc
		 */
		public function get fireOnce():Boolean
		{
			return _fireOnce;
		}

		private var _priority:int;

		/**
		 * @inheritDoc
		 */
		public function get priority():int
		{
			return _priority;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * Creates a Command Mapping
		 * @param commandClass The concrete Command class
		 */
		public function EventCommandMapping(commandClass:Class)
		{
			_commandClass = commandClass;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function withExecuteMethod(name:String):IEventCommandConfigurator
		{
			_executeMethod = name;
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function withGuards(... guards):IEventCommandConfigurator
		{
			_guards = _guards.concat.apply(null, guards);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function withHooks(... hooks):IEventCommandConfigurator
		{
			_hooks = _hooks.concat.apply(null, hooks);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function once(value:Boolean = true):IEventCommandConfigurator
		{
			_fireOnce = value;
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function withPriority(value:int):IEventCommandConfigurator
		{
			_priority = value;
			return this;
		}

		public function toString():String
		{
			return 'Command ' + _commandClass;
		}

	}
}
