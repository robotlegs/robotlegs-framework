//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap.impl
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.commandCenter.api.ICommandCenter;
	import robotlegs.bender.extensions.commandCenter.impl.CommandCenter;
	import robotlegs.bender.extensions.commandCenter.support.NullCommand;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.eventCommandMap.support.SupportEvent;
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMappingConfig;
	import robotlegs.bender.extensions.commandCenter.impl.CommandMappingList;

	public class EventCommandExecutorTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var injector:Injector;

		private var dispatcher:IEventDispatcher;

		private var commandCenter:ICommandCenter;

		private var eventCommandMap:IEventCommandMap;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			injector = new Injector();
			dispatcher = new EventDispatcher();
			commandCenter = new CommandCenter();
			eventCommandMap = new EventCommandMap(injector, dispatcher, commandCenter);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test(expects="robotlegs.bender.framework.api.MappingConfigError")]
		public function incomplete_copy_guard_mapping_throws_mapping_error_when_event_fires():void
		{
			eventCommandMap.map(SupportEvent.TYPE1).toCommand(NullCommand).withGuards(GuardA, GuardB);
			
			const mapping:ICommandMappingConfig = eventCommandMap.map(SupportEvent.TYPE1).toCommand(NullCommand);
			mapping.withGuards(GuardA);
			
			const mappingsList:CommandMappingList = new CommandMappingList();
			mappingsList.head = ICommandMapping(mapping);
			
			const trigger:EventCommandTrigger = new EventCommandTrigger(injector, dispatcher, SupportEvent.TYPE1);
			const executor:EventCommandExecutor = new EventCommandExecutor(trigger, mappingsList, injector, null);
						
			executor.execute(new SupportEvent(SupportEvent.TYPE1));
		}
		
		[Test(expects="robotlegs.bender.framework.api.MappingConfigError")]
		public function incomplete_copy_hook_mapping_throws_mapping_error_when_event_fires():void
		{
			eventCommandMap.map(SupportEvent.TYPE1).toCommand(NullCommand).withHooks(HookA, HookB);
			
			const mapping:ICommandMappingConfig = eventCommandMap.map(SupportEvent.TYPE1).toCommand(NullCommand);
			mapping.withHooks(HookA);

			const mappingsList:CommandMappingList = new CommandMappingList();
			mappingsList.head = ICommandMapping(mapping);
			
			const trigger:EventCommandTrigger = new EventCommandTrigger(injector, dispatcher, SupportEvent.TYPE1);
			const executor:EventCommandExecutor = new EventCommandExecutor(trigger, mappingsList, injector, null);
						
			executor.execute(new SupportEvent(SupportEvent.TYPE1));
		}
	}
}

class GuardA
{
	public function approve():Boolean
	{
		return true;
	}
}

class GuardB
{
	public function approve():Boolean
	{
		return true;
	}
}

class HookA
{
	public function hook():void
	{
	}
}

class HookB
{
	public function hook():void
	{
	}
}