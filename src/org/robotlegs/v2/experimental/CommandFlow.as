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
	
	public class CommandFlow
	{
		
		private const _mappingsFrom:Dictionary = new Dictionary();
		
		[Inject]
		public var eventDispatcher:IEventDispatcher;
		
		[Inject]
		public var injector:Injector;
		
		public function CommandFlow()
		{
		}
		
		public function from(commandClass:Class):ICommandFlowMapping
		{
			trace("CommandFlow::from()", commandClass);
			_mappingsFrom[commandClass] = new CommandFlowMapping(new <Class>[commandClass], eventDispatcher, executionCallback);
			
			return _mappingsFrom[commandClass];
		}
		
		protected function executionCallback(commandFlowRule:ICommandFlowRule):void
		{
			const commandClasses:Vector.<Class> = commandFlowRule.commandClasses;
			for each (var commandClass:Class in commandClasses)
			{
				const command:Object = injector.getInstance(commandClass);
				command.execute();
			}
		}

	}
}