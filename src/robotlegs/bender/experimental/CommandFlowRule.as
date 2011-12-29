//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.experimental
{
	import robotlegs.bender.experimental.ICommandFlowRule;
	import robotlegs.bender.experimental.ICommandFlowConfig;
	import flash.events.Event;
	import robotlegs.bender.core.utilities.pushValuesToClassVector;
	import robotlegs.bender.extensions.guards.impl.GuardGroup;
	import robotlegs.bender.extensions.hooks.impl.HookGroup;
	import robotlegs.bender.extensions.guards.api.IGuardGroup;
	import robotlegs.bender.extensions.hooks.api.IHookGroup;
	import org.swiftsuspenders.Injector;

	public class CommandFlowRule implements ICommandFlowRule, ICommandFlowConfig, ICommandExecutionConfig
	{
		protected const _commandClasses:Vector.<Class> = new Vector.<Class>();

		protected const _receivedEvents:Vector.<Event> = new Vector.<Event>();

		private var _guards:IGuardGroup;

		private var _hooks:IHookGroup;

		public function CommandFlowRule(injector:Injector)
		{
			_guards = new GuardGroup(injector);
			_hooks = new HookGroup(injector);
		}

		public function get guards():IGuardGroup
		{
			return _guards;
		}

		public function get hooks():IHookGroup
		{
			return _hooks;
		}

		public function applyEvent(event:Event):Boolean
		{
			return false;
		}

		public function get commandClasses():Vector.<Class>
		{
			return _commandClasses;
		}

		public function get receivedEvents():Vector.<Event>
		{
			return _receivedEvents;
		}

		public function execute(commandClass:Class):ICommandFlowConfig
		{
			_commandClasses.push(commandClass);
			return this;
		}

		public function executeAll(...commandClassesList):ICommandFlowConfig
		{
			pushValuesToClassVector(commandClassesList, _commandClasses);
			return this;
		}

		public function withGuards():ICommandExecutionConfig
		{
			return this;
		}

		public function withHooks():ICommandExecutionConfig
		{
			return this;
		}
	}
}