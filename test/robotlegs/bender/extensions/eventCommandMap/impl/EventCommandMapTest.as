//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap.impl
{
	import flash.events.EventDispatcher;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.notNullValue;
	import org.hamcrest.object.nullValue;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.commandCenter.api.ICommandCenter;
	import robotlegs.bender.extensions.commandCenter.impl.CommandCenter;
	import robotlegs.bender.extensions.commandCenter.support.NullCommand;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMap;
	import robotlegs.bender.extensions.eventCommandMap.support.SupportEvent;
	import robotlegs.bender.extensions.commandCenter.api.CommandMappingError;

	public class EventCommandMapTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var injector:Injector;

		private var dispatcher:EventDispatcher;

		private var commandCenter:ICommandCenter;

		private var eventCommandMap:IEventCommandMap;
		
		private var errorImport:CommandMappingError;

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

		[Test]
		public function mapEvent_creates_mapper():void
		{
			assertThat(eventCommandMap.map(SupportEvent.TYPE1, SupportEvent), notNullValue());
		}

		[Test]
		public function mapEvent_to_command_stores_mapping():void
		{
			eventCommandMap.map(SupportEvent.TYPE1).toCommand(NullCommand);
			assertThat(eventCommandMap.getMapping(SupportEvent.TYPE1).forCommand(NullCommand), notNullValue());
		}

		[Test]
		public function unmapEvent_from_command_removes_mapping():void
		{
			eventCommandMap.map(SupportEvent.TYPE1).toCommand(NullCommand);
			eventCommandMap.unmap(SupportEvent.TYPE1).fromCommand(NullCommand);
			assertThat(eventCommandMap.getMapping(SupportEvent.TYPE1).forCommand(NullCommand), nullValue());
		}
		
		[Test(expects="robotlegs.bender.extensions.commandCenter.api.CommandMappingError")]
		public function different_guard_mapping_throws_mapping_error():void
		{
			eventCommandMap.map(SupportEvent.TYPE1).toCommand(NullCommand).withGuards(GuardA, GuardB);
			eventCommandMap.map(SupportEvent.TYPE1).toCommand(NullCommand).withGuards(GuardA, GuardC);
		}
		
		[Test(expects="robotlegs.bender.extensions.commandCenter.api.CommandMappingError")]
		public function different_hook_mapping_throws_mapping_error():void
		{
			eventCommandMap.map(SupportEvent.TYPE1).toCommand(NullCommand).withHooks(HookA, HookC);
			eventCommandMap.map(SupportEvent.TYPE1).toCommand(NullCommand).withHooks(HookB);
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

class GuardC
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

class HookC
{
	public function hook():void
	{
	}
}
