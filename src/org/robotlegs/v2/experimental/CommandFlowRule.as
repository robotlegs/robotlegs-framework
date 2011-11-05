//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.experimental
{
	import org.robotlegs.v2.experimental.ICommandFlowRule;
	import org.robotlegs.v2.experimental.ICommandFlowConfig;
	import flash.events.Event;
	import org.robotlegs.v2.extensions.guardsAndHooks.api.IGuardsAndHooksConfig;
	import org.robotlegs.v2.extensions.guardsAndHooks.impl.GuardsAndHooksConfig;
	import org.robotlegs.v2.core.utilities.pushValuesToClassVector;

	public class CommandFlowRule extends GuardsAndHooksConfig implements ICommandFlowRule, ICommandFlowConfig
	{
		protected const _commandClasses:Vector.<Class> = new Vector.<Class>();
	
		protected const _receivedEvents:Vector.<Event> = new Vector.<Event>();
		
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
		
		public function execute(commandClass:Class):IGuardsAndHooksConfig
		{
			_commandClasses.push(commandClass);
			return this;
		}

		public function executeAll(...commandClassesList):IGuardsAndHooksConfig
		{
			pushValuesToClassVector(commandClassesList, _commandClasses);
			return this;
		}
	}
}