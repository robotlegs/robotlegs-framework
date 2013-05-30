//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;

	/**
	 * @private
	 */
	public class CommandMapping implements ICommandMapping
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

		private var _payloadInjectionEnabled:Boolean = true;

		/**
		 * @inheritDoc
		 */
		public function get payloadInjectionEnabled():Boolean
		{
			return _payloadInjectionEnabled;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * Creates a Command Mapping
		 * @param commandClass The concrete Command class
		 */
		public function CommandMapping(commandClass:Class)
		{
			_commandClass = commandClass;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function setExecuteMethod(name:String):ICommandMapping
		{
			_executeMethod = name;
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function addGuards(... guards):ICommandMapping
		{
			_guards = _guards.concat.apply(null, guards);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function addHooks(... hooks):ICommandMapping
		{
			_hooks = _hooks.concat.apply(null, hooks);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function setFireOnce(value:Boolean):ICommandMapping
		{
			_fireOnce = value;
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function setPayloadInjectionEnabled(value:Boolean):ICommandMapping
		{
			_payloadInjectionEnabled = value;
			return this;
		}

		public function toString():String
		{
			return 'Command ' + _commandClass;
		}
	}
}
