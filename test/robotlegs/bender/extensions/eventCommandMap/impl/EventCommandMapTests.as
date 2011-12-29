//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap.impl
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.notNullValue;
	import org.hamcrest.object.nullValue;
	import robotlegs.bender.extensions.commandMap.support.NullCommand;
	import robotlegs.bender.extensions.eventCommandMap.support.SupportEvent;

	public class EventCommandMapTests extends AbstractEventCommandMapTests
	{

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
	}
}
