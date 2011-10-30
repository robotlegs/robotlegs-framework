//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.impl 
{
	import org.flexunit.asserts.*;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediator;
	import flash.display.Sprite;
	import org.robotlegs.v2.extensions.mediatorMap.impl.support.MediatorWatcher;
	import org.robotlegs.v2.extensions.mediatorMap.impl.support.TrackingMediator;

	public class MediatorTest 
	{
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var instance:Mediator;
		
		private var mediatorWatcher:MediatorWatcher;
		
		private var trackingMediator:TrackingMediator;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function setUp():void
		{
			instance = new Mediator();
			mediatorWatcher = new MediatorWatcher();
			trackingMediator = new TrackingMediator(mediatorWatcher);
		}

		[After]
		public function tearDown():void
		{
			instance = null;
			mediatorWatcher = null;
			trackingMediator = null;
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function can_be_instantiated():void
		{
			assertTrue("instance is Mediator", instance is Mediator);
		}
		
		[Test]
		public function implements_IMediator():void
		{
			assertTrue(instance is IMediator)
		}
		
		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}
		
		[Test]
		public function getViewComponent_matches_setViewComponent():void {
			const view:Sprite = new Sprite();
			instance.setViewComponent(view);
			assertEquals(view, instance.getViewComponent());
		}

		[Test]
		public function preRegister_runs_onRegister_immediately_for_nonFlex():void
		{
			trackingMediator.setViewComponent(new Sprite());
			trackingMediator.preRegister();
			var expectedNotifications:Vector.<String> = new <String>[TrackingMediator.ON_REGISTER];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}
		
		[Test]
		public function preRemove_runs_onRemove_immediately_for_nonFlex():void
		{
			trackingMediator.setViewComponent(new Sprite());
			trackingMediator.preRemove();
			var expectedNotifications:Vector.<String> = new <String>[TrackingMediator.ON_REMOVE];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}
		
		// mediator pauses event map on view removed and resumes again on view added
		
		// flex workarounds for creation complete etc
		
		// sugar methods for add / remove view listener and context listener
		
		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/
		
	}
}