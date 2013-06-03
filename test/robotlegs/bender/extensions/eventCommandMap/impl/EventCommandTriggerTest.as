//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap.impl
{
	import flash.events.IEventDispatcher;
	import mockolate.received;
	import mockolate.runner.MockolateRule;
	import org.hamcrest.assertThat;
	import robotlegs.bender.framework.impl.RobotlegsInjector;

	public class EventCommandTriggerTest
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var dispatcher:IEventDispatcher;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var subject:EventCommandTrigger;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			subject = new EventCommandTrigger(new RobotlegsInjector(), dispatcher, null, null);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function activating_adds_listener():void
		{
			subject.activate();
			assertThat(dispatcher, received().method('addEventListener').once());
		}

		[Test]
		public function deactivating_removes_listener():void
		{
			subject.deactivate();
			assertThat(dispatcher, received().method('removeEventListener').once());
		}
	}
}
