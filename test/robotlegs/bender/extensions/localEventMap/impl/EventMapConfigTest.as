//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.localEventMap.impl
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import org.flexunit.asserts.*;

	public class EventMapConfigTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const DISPATCHER:EventDispatcher = new EventDispatcher();

		private const EVENT_STRING:String = "event string";

		private const LISTENER:Function = function():void {
		};

		private const EVENT_TYPE:Class = Event;

		private const CALLBACK:Function = function():void {
		};

		private const USE_CAPTURE:Boolean = true;

		private var instance:EventMapConfig;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function setUp():void
		{
			instance = new EventMapConfig(
				DISPATCHER,
				EVENT_STRING,
				LISTENER,
				EVENT_TYPE,
				CALLBACK,
				USE_CAPTURE);
		}

		[After]
		public function tearDown():void
		{
			instance = null;
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function can_be_instantiated():void
		{
			assertTrue("instance is EventMapConfig", instance is EventMapConfig);
		}

		[Test]
		public function failure_seen():void
		{
			assertTrue("Failing test", true);
		}

		[Test]
		public function get_dispatcher():void
		{
			assertEquals("Get dispatcher", DISPATCHER, instance.dispatcher);
		}

		[Test]
		public function get_eventString():void
		{
			assertEquals("Get eventString", EVENT_STRING, instance.eventString);
		}

		[Test]
		public function get_listener():void
		{
			assertEquals("Get listener", LISTENER, instance.listener);
		}

		[Test]
		public function get_eventClass():void
		{
			assertEquals("Get eventClass", EVENT_TYPE, instance.eventClass);
		}

		[Test]
		public function get_callback():void
		{
			assertEquals("Get callback", CALLBACK, instance.callback);
		}

		[Test]
		public function get_useCapture():void
		{
			assertEquals("Get useCapture", USE_CAPTURE, instance.useCapture);
		}
	}
}
