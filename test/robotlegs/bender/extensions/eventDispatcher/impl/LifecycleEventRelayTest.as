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
	import org.hamcrest.collection.hasItem;
	import robotlegs.bender.framework.api.LifecycleEvent;
	import robotlegs.bender.framework.impl.Context;

	public class LifecycleEventRelayTest
	{

		/*============================================================================*/
		/* Private Static Properties                                                  */
		/*============================================================================*/

		private static const LIFECYCLE_TYPES:Array = [
			LifecycleEvent.PRE_INITIALIZE, LifecycleEvent.INITIALIZE, LifecycleEvent.POST_INITIALIZE,
			LifecycleEvent.PRE_SUSPEND, LifecycleEvent.SUSPEND, LifecycleEvent.POST_SUSPEND,
			LifecycleEvent.PRE_RESUME, LifecycleEvent.RESUME, LifecycleEvent.POST_RESUME,
			LifecycleEvent.PRE_DESTROY, LifecycleEvent.DESTROY, LifecycleEvent.POST_DESTROY];

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var context:Context;

		private var dispatcher:IEventDispatcher;

		private var subject:LifecycleEventRelay;

		private var reportedTypes:Array;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			context = new Context();
			dispatcher = new EventDispatcher();
			subject = new LifecycleEventRelay(context, dispatcher);
			reportedTypes = [];
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function state_change_is_relayed():void
		{
			listenFor([LifecycleEvent.STATE_CHANGE]);
			context.initialize();
			assertThat(reportedTypes, hasItem(LifecycleEvent.STATE_CHANGE));
		}

		[Test]
		public function lifecycle_events_are_relayed():void
		{
			listenFor(LIFECYCLE_TYPES);
			context.initialize();
			context.suspend();
			context.resume();
			context.destroy();
			assertThat(reportedTypes, array(LIFECYCLE_TYPES));
		}

		[Test]
		public function lifecycle_events_are_NOT_relayed_after_destroy():void
		{
			listenFor(LIFECYCLE_TYPES);
			subject.destroy();
			context.initialize();
			context.suspend();
			context.resume();
			context.destroy();
			assertThat(reportedTypes, emptyArray());
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function listenFor(types:Array):void
		{
			for each (var type:String in types)
			{
				dispatcher.addEventListener(type, catchEvent);
			}
		}

		private function catchEvent(event:Event):void
		{
			reportedTypes.push(event.type);
		}
	}
}
