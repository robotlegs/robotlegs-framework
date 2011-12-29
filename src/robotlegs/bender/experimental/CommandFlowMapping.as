//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.experimental
{
	import robotlegs.bender.experimental.ICommandFlowMapping;
	import flash.events.IEventDispatcher;
	import robotlegs.bender.core.utilities.pushValuesToClassVector;
	import robotlegs.bender.experimental.ICommandFlowRule;
	import robotlegs.bender.experimental.CommandFlowRequireOnlyRule;
	import robotlegs.bender.experimental.CommandFlowRequireAllRule;
	import flash.events.Event;
	import org.swiftsuspenders.Injector;

	public class CommandFlowMapping implements ICommandFlowMapping
	{

		private var _from:Vector.<Class>;

		private var _eventDispatcher:IEventDispatcher;

		private const _eventStrings:Vector.<String> = new Vector.<String>();

		private var _rule:CommandFlowRule;

		private var _executionCallback:Function;

		private var _requireAllFrom:Boolean;

		private var _injector:Injector;

		public function CommandFlowMapping(from:Vector.<Class>, eventDispatcher:IEventDispatcher, executionCallback:Function, requireAllFrom:Boolean, injector:Injector)
		{
			_from = from;
			_eventDispatcher = eventDispatcher;
			_executionCallback = executionCallback;
			_requireAllFrom = requireAllFrom;
			_injector = injector;
		}

		public function after(eventString:String):ICommandFlowConfig
		{
			_eventStrings.push(eventString);
			_rule = new CommandFlowRequireOnlyRule(eventString, _injector);
			return _rule;
		}

		public function afterAll(...eventStrings):ICommandFlowConfig
		{
			pushValuesToStringVector(eventStrings, _eventStrings);
			_rule = new CommandFlowRequireAllRule(_eventStrings, _injector);
			return _rule;
		}

		public function afterAny(...eventStrings):ICommandFlowConfig
		{
			pushValuesToStringVector(eventStrings, _eventStrings);
			_rule = new CommandFlowRequireAnyRule(_eventStrings, _injector);
			return _rule;
		}

		internal function get from():Vector.<Class>
		{
			return _from;
		}

		internal function get requireAllFrom():Boolean
		{
			return _requireAllFrom;
		}

		internal function activate():void
		{
			for each (var eventString:String in _eventStrings)
			{
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
				deactivate();
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

		private function get applyAtStart():Boolean
		{
			return ((_from.length == 1) && (_from[0] == CommandFlowStart));
		}
	}
}