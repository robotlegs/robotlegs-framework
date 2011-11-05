//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.experimental
{
	import org.robotlegs.v2.experimental.ICommandFlowMapping;
	import flash.events.IEventDispatcher;
	import org.robotlegs.v2.core.utilities.pushValuesToClassVector;
	import org.robotlegs.v2.experimental.ICommandFlowRule;
	import org.robotlegs.v2.experimental.CommandFlowRequireOnlyRule;
	import org.robotlegs.v2.experimental.CommandFlowRequireAllRule;
	import flash.events.Event;

	public class CommandFlowMapping implements ICommandFlowMapping
	{

		private var _from:Vector.<Class>;

		private var _eventDispatcher:IEventDispatcher;
		
		private const _eventStrings:Vector.<String> = new Vector.<String>();
		
		private var _rule:CommandFlowRule;
		
		private var _executionCallback:Function;

		public function CommandFlowMapping(from:Vector.<Class>, eventDispatcher:IEventDispatcher, executionCallback:Function)
		{
			_from = from;
			_eventDispatcher = eventDispatcher;
			_executionCallback = executionCallback;
		}
		
		public function after(eventString:String):ICommandFlowConfig
		{
			trace("CommandFlowMapping::after()", eventString);
			_eventStrings.push(eventString);
			_rule = new CommandFlowRequireOnlyRule(eventString);
			activate();
			return _rule;
		}

		public function afterAll(...eventStrings):ICommandFlowConfig
		{
			pushValuesToStringVector(eventStrings, _eventStrings);
			_rule = new CommandFlowRequireAllRule(_eventStrings);
			activate();
			return _rule;
		}

		public function afterAny(...eventStrings):ICommandFlowConfig
		{
			pushValuesToStringVector(eventStrings, _eventStrings);
			_rule = new CommandFlowRequireAnyRule(_eventStrings);
			activate();
			return _rule;
		}
		
		internal function get from():Vector.<Class>
		{
			return _from;
		}	
		
		internal function activate():void
		{
			trace("CommandFlowMapping::activate()");
			for each (var eventString:String in _eventStrings)
			{
				trace("CommandFlowMapping::activate()", eventString);
				_eventDispatcher.addEventListener(eventString, supplyEventToRule);
			}
		}
		
		internal function deactivate():void
		{
			for each (var eventString:String in _eventStrings)
			{
				_eventDispatcher.removeEventListener(eventString, supplyEventToRule);
			}			
		}
		
		private function supplyEventToRule(event:Event):void
		{
			if(_rule.applyEvent(event))
			{
				_executionCallback(_rule);
			}
		}
		
		private function pushValuesToStringVector(values:Array, vector:Vector.<String>):void
		{
			if (values.length == 1
				&& (values[0] is Array || values[0] is Vector.<String>))
			{
				for each (var type:String in values[0])
				{
					vector.push(type);
				}
			}
			else
			{
				for each (type in values)
				{
					vector.push(type);
				}
			}
		}
	}
}