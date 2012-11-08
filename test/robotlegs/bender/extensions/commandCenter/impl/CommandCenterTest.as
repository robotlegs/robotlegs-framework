//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import robotlegs.bender.extensions.commandCenter.api.ICommandCenter;
	import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
	import robotlegs.bender.extensions.commandCenter.support.NullCommandTrigger;

	public class CommandCenterTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var commandCenter:ICommandCenter;

		private var trigger:ICommandTrigger;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			commandCenter = new CommandCenter();
			trigger = new NullCommandTrigger();
		}

		[After]
		public function after():void
		{
			commandCenter = null;
			trigger = null;
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function map_creates_mapper():void
		{
			assertThat(commandCenter.map(trigger), instanceOf(ICommandMapper));
		}

		[Test]
		public function map_to_identical_trigger_returns_existing_mapper():void
		{
			const mapper:ICommandMapper = commandCenter.map(trigger);
			assertThat(commandCenter.map(trigger), equalTo(mapper));
		}

		[Test]
		public function unmap_returns_unmapper():void
		{
			const mapper:ICommandMapper = commandCenter.map(trigger);
			assertThat(commandCenter.unmap(trigger), equalTo(mapper));
		}

		[Test]
		public function unmap_politely_returns_NullUnmapper():void
		{
			assertThat(commandCenter.unmap(trigger), instanceOf(NullCommandUnmapper));
		}
	}
}
