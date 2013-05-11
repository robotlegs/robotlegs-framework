//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventDispatcher.impl
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.collection.emptyArray;

	import robotlegs.bender.extensions.eventDispatcher.impl.EventRelay;

	public class EventRelayTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var source:IEventDispatcher;

		private var destination:IEventDispatcher;

		private var subject:EventRelay;

		private var reportedTypes:Array;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			source = new EventDispatcher();
			destination = new EventDispatcher();
			reportedTypes = [];
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function no_relay_before_start():void
		{
			createRelayFor(["test1"]);
			source.dispatchEvent(new Event("test1"));
			assertThat(reportedTypes, emptyArray());
		}

		[Test]
		public function relays_specified_events():void
		{
			createRelayFor(["test1", "test2"]).start();
			source.dispatchEvent(new Event("test1"));
			source.dispatchEvent(new Event("test2"));
			assertThat(reportedTypes, array("test1", "test2"));
		}

		[Test]
		public function ignores_unspecified_events():void
		{
			createRelayFor([]).start();
			source.dispatchEvent(new Event("test1"));
			assertThat(reportedTypes, emptyArray());
		}

		[Test]
		public function relays_specified_events_but_ignores_unspecified_events():void
		{
			createRelayFor(["test1"]).start();
			source.dispatchEvent(new Event("test1"));
			source.dispatchEvent(new Event("test2"));
			assertThat(reportedTypes, array("test1"));
		}

		[Test]
		public function no_relay_after_stop():void
		{
			createRelayFor(["test1"]).start().stop();
			source.dispatchEvent(new Event("test1"));
			assertThat(reportedTypes, emptyArray());
		}

		[Test]
		public function relay_resumes():void
		{
			createRelayFor(["test1"]).start().stop().start();
			source.dispatchEvent(new Event("test1"));
			assertThat(reportedTypes, array("test1"));
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function createRelayFor(types:Array):EventRelay
		{
			subject = new EventRelay(source, destination, types);
			for each (var type:String in types)
			{
				destination.addEventListener(type, catchEvent);
			}
			return subject;
		}

		private function catchEvent(event:Event):void
		{
			reportedTypes.push(event.type);
		}
	}
}
