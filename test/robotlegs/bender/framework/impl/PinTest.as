//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import flash.events.IEventDispatcher;
	import mockolate.received;
	import mockolate.runner.MockolateRule;
	import org.flexunit.assertThat;
	import org.hamcrest.Matcher;
	import org.hamcrest.core.allOf;
	import org.hamcrest.core.anyOf;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.hasProperties;
	import org.hamcrest.object.instanceOf;
	import robotlegs.bender.framework.api.PinEvent;

	public class PinTest
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

		private var pin:Pin;

		private var instance:Object;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			instance = {};
			pin = new Pin(dispatcher);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function detain_dispatches_event():void
		{
			pin.detain(instance);
			assertThat(dispatcher, received()
				.method('dispatchEvent')
				.arg(pinEventMatcher(PinEvent.DETAIN))
				.once());
		}

		[Test]
		public function detain_dispatches_event_once_per_valid_detainment():void
		{
			pin.detain(instance);
			pin.detain(instance);
			assertThat(dispatcher, received()
				.method('dispatchEvent')
				.arg(pinEventMatcher(PinEvent.DETAIN))
				.once());
		}

		[Test]
		public function release_dispatches_event():void
		{
			pin.detain(instance);
			pin.release(instance);
			assertThat(dispatcher, received()
				.method('dispatchEvent')
				.arg(pinEventMatcher(PinEvent.RELEASE))
				.once());
		}

		[Test]
		public function release_dispatches_event_once_per_valid_release():void
		{
			pin.detain(instance);
			pin.release(instance);
			pin.release(instance);
			assertThat(dispatcher, received()
				.method('dispatchEvent')
				.arg(pinEventMatcher(PinEvent.RELEASE))
				.once());
		}

		[Test]
		public function release_does_not_dispatch_event_if_instance_was_not_detained():void
		{
			pin.release(instance);
			assertThat(dispatcher, received()
				.method('dispatchEvent')
				.arg(pinEventMatcher(PinEvent.RELEASE))
				.never());
		}

		[Test]
		public function releaseAll_dispatches_events_for_all_instances():void
		{
			const instanceA:Object = {};
			const instanceB:Object = {};
			const instanceC:Object = {};
			pin.detain(instanceA);
			pin.detain(instanceB);
			pin.detain(instanceC);
			pin.releaseAll();
			assertThat(dispatcher, received()
				.method('dispatchEvent')
				.arg(allOf(instanceOf(PinEvent), hasProperties({
					type: PinEvent.RELEASE,
					instance: anyOf(
						equalTo(instanceA),
						equalTo(instanceB),
						equalTo(instanceC))})))
				.thrice());
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function pinEventMatcher(type:String):Matcher
		{
			return allOf(
				instanceOf(PinEvent),
				hasProperties({type: type, instance: instance}));
		}
	}
}
