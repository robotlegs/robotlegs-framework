//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.modularity.impl
{
	import flash.events.IEventDispatcher;
	import mockolate.received;
	import mockolate.runner.MockolateRule;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.instanceOf;
	import robotlegs.bender.extensions.eventCommandMap.support.SupportEvent;

	public class ModuleConnectionConfiguratorTest
	{

		/*============================================================================*/
		/* Private Static Properties                                                  */
		/*============================================================================*/

		private static const GLOBAL_CHANNEL_ID:String = 'global';

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Rule]
		public var mockolateRule:MockolateRule = new MockolateRule();

		[Mock]
		public var channelDispatcher:IEventDispatcher;

		[Mock]
		public var localDispatcher:IEventDispatcher;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var subject:ModuleConnectionConfigurator;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			subject = new ModuleConnectionConfigurator(localDispatcher, channelDispatcher);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function sets_up_relaying_from_local_to_channel():void
		{
			subject.relayEvent(SupportEvent.TYPE1);
			assertThat(localDispatcher, received().method('addEventListener').args(
				SupportEvent.TYPE1, channelDispatcher.dispatchEvent).once());
		}

		[Test]
		public function sets_up_receiving_from_channel_to_local():void
		{
			subject.receiveEvent(SupportEvent.TYPE1);
			assertThat(channelDispatcher, received().method('addEventListener').args(
				SupportEvent.TYPE1, localDispatcher.dispatchEvent).once());
		}

		[Test]
		public function suspends_relaying():void
		{
			subject.relayEvent(SupportEvent.TYPE1);
			subject.suspend();
			assertThat(localDispatcher, received().method('removeEventListener').args(
				SupportEvent.TYPE1, instanceOf(Function)).once());
		}

		[Test]
		public function resumes_relaying():void
		{
			subject.relayEvent(SupportEvent.TYPE1);
			subject.suspend();
			subject.resume();
			assertThat(localDispatcher, received().method('addEventListener').args(
				SupportEvent.TYPE1, channelDispatcher.dispatchEvent).twice());
		}

		[Test]
		public function suspends_receiving():void
		{
			subject.receiveEvent(SupportEvent.TYPE1);
			subject.suspend();
			assertThat(channelDispatcher, received().method('removeEventListener').args(
				SupportEvent.TYPE1, instanceOf(Function)).once());
		}

		[Test]
		public function resumes_receiving():void
		{
			subject.receiveEvent(SupportEvent.TYPE1);
			subject.suspend();
			subject.resume();
			assertThat(channelDispatcher, received().method('addEventListener').args(
				SupportEvent.TYPE1, localDispatcher.dispatchEvent).twice());
		}

		[Test]
		public function removes_listeners_after_destruction():void
		{
			subject.relayEvent(SupportEvent.TYPE1);
			subject.receiveEvent(SupportEvent.TYPE2);
			subject.destroy();
			assertThat(localDispatcher, received().method('removeEventListener').args(
				SupportEvent.TYPE1, instanceOf(Function)).once());
			assertThat(channelDispatcher, received().method('removeEventListener').args(
				SupportEvent.TYPE2, instanceOf(Function)).once());
		}
	}
}
