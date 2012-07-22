//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMappingConfig;
	import robotlegs.bender.extensions.commandCenter.api.CommandMappingError;

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

		private var _once:Boolean;

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
			_locked && validate(guards, _guards);
			_guards = _guards.concat.apply(null, guards);
			return this;
		}

		public function withHooks(... hooks):ICommandMappingConfig
		{
			_locked && validate(hooks, _hooks);
			_hooks = _hooks.concat.apply(null, hooks);
			return this;
		}

		public function get fireOnce():Boolean
		{
			return _once;
		}

		public function once(value:Boolean = true):ICommandMappingConfig
		{
			_locked && (!_once) && throwMappingError("You attempted to change an existing mapping for " 
											+ _commandClass + " by setting once(). Please unmap first.");
			_once = value;
			return this;
		}
		
		private var _locked:Boolean = false;
		
		public function lock():void
		{
			_locked = true;
		}
		
		private function validate(provided:*, existing:Array):void
		{
			provided = [].concat.apply(null, provided);
			const iLength:uint = provided.length;
			for (var i:uint = 0; i < iLength; i++)
			{
				if(existing.indexOf(provided[i]) == -1)
					throwMappingError(configChangeMessage(provided[i]));
			}
		}
		
		private function throwMappingError(msg:String):void
		{
			throw new CommandMappingError(msg)
		}
		
		private function configChangeMessage(item:Object):String
		{
			return "You attempted to change an existing mapping for " + _commandClass.toString 
					+ " by adding " + item.toString() + ". Please unmap first.";
		}
	}
}