//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMapA 
{
	import org.flexunit.asserts.*;
	import org.robotlegs.v2.extensions.mediatorMapA.support.MicroAppWithMediator;
	import flash.display.MovieClip;
	import mx.core.UIComponent;
	import mx.core.FlexGlobals;
	import org.fluint.uiImpersonation.UIImpersonator;
	import flash.events.Event;
	import org.robotlegs.v2.extensions.mediatorMapA.impl.support.MediatorWatcher;
	import org.robotlegs.v2.extensions.mediatorMapA.api.IMediator;
	import org.robotlegs.core.IMediator;
	import org.robotlegs.v2.extensions.mediatorMapA.support.MicroAppWithMixedMediators;
	import org.robotlegs.v2.extensions.mediatorMapA.support.MicroAppWithV1Mediators;

	public class MediatorMapExtensionTest 
	{
		private var instance:MediatorMapExtension;
		
		private var microApp:MicroAppWithMediator;
		
		private var microAppWithMixedMediators:MicroAppWithMixedMediators;
		
		private var microAppWithV1Mediators:MicroAppWithV1Mediators;
		
		private var mediatorWatcher:MediatorWatcher;
		
		private var view:MovieClip;
		
		[Before]
		public function setUp():void
		{
			instance = new MediatorMapExtension();
			mediatorWatcher = new MediatorWatcher();
			view = new MovieClip();
		}

		[After]
		public function tearDown():void
		{
			instance = null;
			mediatorWatcher = null;
			view = null;
			UIImpersonator.removeAllChildren();
		}

		[Test]
		public function can_be_instantiated():void
		{
			assertTrue("instance is MediatorMapExtension", instance is MediatorMapExtension);
		}

		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}
		
		[Test(async,ui)]
		public function micro_app_with_mediator_notifies_mediator_watcher_and_mediator_contains_view():void
		{
			microApp = new MicroAppWithMediator();
			var group:UIComponent = new UIComponent();
			group.addChild(microApp);
			UIImpersonator.addChild(group);
			
			microApp.buildContext(buildCompleteHandler, mediatorWatcher);
			
			const reportedMediators:Array = mediatorWatcher.trackedMediators;
			
			const reportedMediator:org.robotlegs.v2.extensions.mediatorMapA.api.IMediator = reportedMediators[0];
			
			assertEquals(view, reportedMediator.getViewComponent());
		}
		
		protected function buildCompleteHandler(e:Event):void
		{
			microApp.addChild(view);
		}
		
		[Test(async,ui)]
		public function two_mediators_can_live_along_side_each_other_happily():void
		{
			microAppWithMixedMediators = new MicroAppWithMixedMediators();
			var group:UIComponent = new UIComponent();
			group.addChild(microAppWithMixedMediators);
			UIImpersonator.addChild(group);
			
			microAppWithMixedMediators.buildContext(buildCompleteHandlerForMixedMediators, mediatorWatcher);
			
			const reportedMediators:Array = mediatorWatcher.trackedMediators;
			
			assertEquals(2, reportedMediators.length)
			
			assertEquals(view, reportedMediators[0].getViewComponent());
			assertEquals(view, reportedMediators[1].getViewComponent());
			
			assertTrue(reportedMediators[0] is org.robotlegs.v2.extensions.mediatorMapA.api.IMediator);
			assertTrue(reportedMediators[1] is org.robotlegs.core.IMediator);
		}
		
		protected function buildCompleteHandlerForMixedMediators(e:Event):void
		{
			microAppWithMixedMediators.addChild(view);
		}
		
		[Test(async,ui)]
		public function micro_app_with_v1_mediator_notifies_mediator_watcher():void
		{
			microAppWithV1Mediators = new MicroAppWithV1Mediators();
			var group:UIComponent = new UIComponent();
			group.addChild(microAppWithV1Mediators);
			UIImpersonator.addChild(group);
			
			microAppWithV1Mediators.buildContext(buildCompleteHandlerForV1Mediators, mediatorWatcher);
			
			const reportedMediators:Array = mediatorWatcher.trackedMediators;
			
			const reportedMediator:org.robotlegs.core.IMediator = reportedMediators[0];
			
			assertEquals(view, reportedMediator.getViewComponent());
		}
		
		protected function buildCompleteHandlerForV1Mediators(e:Event):void
		{
			microAppWithV1Mediators.addChild(view);
		}
	}
}