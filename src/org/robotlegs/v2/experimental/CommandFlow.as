//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.experimental
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;
	import org.swiftsuspenders.Injector;
	import org.robotlegs.v2.experimental.CommandFlowStart;
	import org.robotlegs.v2.core.utilities.pushValuesToClassVector;
	
	public class CommandFlow
	{
		
		private const _mappingsFrom:Dictionary = new Dictionary();
		
		private const _executedCommands:Dictionary = new Dictionary();
		
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		[Inject]
		public var injector:Injector;
		
		public function initialize():void
		{
			checkIfMappingsShouldBeActive(_mappingsFrom[CommandFlowStart]);
		}
		
		public function from(commandClass:Class):ICommandFlowMapping
		{
			const mapping:CommandFlowMapping = new CommandFlowMapping(new <Class>[commandClass], eventDispatcher, executionCallback, false, injector);

			addMappingTo(mapping, commandClass);
			return mapping;
		}
		
		public function fromAll(...commandClasses):ICommandFlowMapping
		{
			return fromMultipleCommands(true, commandClasses);
		}
		
		public function fromAny(...commandClasses):ICommandFlowMapping
		{
			return fromMultipleCommands(false, commandClasses);
		}
		
		private function fromMultipleCommands(requireFromAll:Boolean, ...commandClasses):ICommandFlowMapping
		{
			const commandVector:Vector.<Class> = new Vector.<Class>();
			pushValuesToClassVector(commandClasses, commandVector);
			
			const mapping:CommandFlowMapping = new CommandFlowMapping(commandVector, eventDispatcher, executionCallback, requireFromAll, injector);
			
			for each (var commandClass:Class in commandVector)
			{
				addMappingTo(mapping, commandClass);
			}
			
			return mapping;
		}
		
		private function executionCallback(commandFlowRule:ICommandFlowRule):void
		{
			const commandClasses:Vector.<Class> = commandFlowRule.commandClasses;
			for each (var commandClass:Class in commandClasses)
			{
				const command:Object = injector.getInstance(commandClass);
				command.execute();
				_executedCommands[commandClass] = commandClass;
				
				if(_mappingsFrom[commandClass])
				{
					checkIfMappingsShouldBeActive(_mappingsFrom[commandClass]);
				}
			}
		}

		private function checkIfMappingsShouldBeActive(mappings:Vector.<CommandFlowMapping>):void
		{
			var requiredFromCommands:Vector.<Class>;
			var readyToActivate:Boolean;
			
			for each (var mapping:CommandFlowMapping in mappings)
			{
				readyToActivate = true;
				requiredFromCommands = mapping.from;
				for each (var commandClass:Class in requiredFromCommands)
				{
					if((!mapping.requireAllFrom) && _executedCommands[commandClass])
						break;
					
					if(mapping.requireAllFrom && (!_executedCommands[commandClass]))
					{
						readyToActivate = false;
						break;
					}
				}
				if(readyToActivate)
				{
					mapping.activate();
				}
			}
		}
		
		private function addMappingTo(mapping:CommandFlowMapping, commandClass:Class):void
		{
			var mappings:Vector.<CommandFlowMapping>;
			if(_mappingsFrom[commandClass])
			{
				mappings = _mappingsFrom[commandClass];
			}
			else
			{
				mappings = new Vector.<CommandFlowMapping>();
				_mappingsFrom[commandClass] = mappings;
			}
			mappings.push(mapping);
		}

	}
}