//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import mx.core.UIComponent;
	import org.flexunit.Assert;
	import org.flexunit.async.Async;
	import org.fluint.uiImpersonation.UIImpersonator;
	import org.robotlegs.adapters.SwiftSuspendersInjector;
	import org.robotlegs.adapters.SwiftSuspendersReflector;
	import org.robotlegs.core.IEventMap;
	import org.robotlegs.core.IInjector;
	import org.robotlegs.core.IMediator;
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.core.IReflector;
	import org.robotlegs.mvcs.support.NonViewComponent;
	import org.robotlegs.mvcs.support.NonViewMediator;
	import org.robotlegs.mvcs.support.TestContextView;
	import org.robotlegs.mvcs.support.TestContextViewMediator;
	import org.robotlegs.mvcs.support.ViewComponent;
	import org.robotlegs.mvcs.support.ViewComponentAdvanced;
	import org.robotlegs.mvcs.support.ViewMediator;
	import org.robotlegs.mvcs.support.ViewMediatorAdvanced;

	public class MediatorMapV1Test
	{

		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/

		public static const TEST_EVENT:String = 'testEvent';


		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected var commandExecuted:Boolean;

		protected var contextView:DisplayObjectContainer;

		protected var eventDispatcher:IEventDispatcher;

		protected var eventMap:IEventMap;

		protected var injector:IInjector;

		protected var mediatorMap:MediatorMap;

		protected var reflector:IReflector;


		/*============================================================================*/
		/* Public Static Functions                                                    */
		/*============================================================================*/

		[AfterClass]
		public static function runAfterEntireSuite():void
		{
		}

		[BeforeClass]
		public static function runBeforeEntireSuite():void
		{
		}

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[After(ui)]
		public function runAfterEachTest():void
		{
			UIImpersonator.removeAllChildren();
			injector.unmap(IMediatorMap);
		}

		[Before(ui)]
		public function runBeforeEachTest():void
		{
			contextView = new TestContextView();
			eventDispatcher = new EventDispatcher();
			injector = new SwiftSuspendersInjector();
			reflector = new SwiftSuspendersReflector();
			mediatorMap = new MediatorMap(contextView, injector, reflector);

			injector.mapValue(DisplayObjectContainer, contextView);
			injector.mapValue(IInjector, injector);
			injector.mapValue(IEventDispatcher, eventDispatcher);
			injector.mapValue(IMediatorMap, mediatorMap);

			UIImpersonator.addChild(contextView);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/


		[Test]
		public function contextViewMediatorIsCreatedWhenMapped():void
		{
			mediatorMap.mapView(TestContextView, TestContextViewMediator);
			Assert.assertTrue('Mediator should have been created for contextView', mediatorMap.hasMediatorForView(contextView));
		}

		[Test]
		public function contextViewMediatorIsNotCreatedWhenMappedAndAutoCreateIsFalse():void
		{
			mediatorMap.mapView(TestContextView, TestContextViewMediator, null, false);
			Assert.assertFalse('Mediator should NOT have been created for contextView', mediatorMap.hasMediatorForView(contextView));
		}


		[Test]
		public function mediatorIsMappedAddedAndRemovedByView():void
		{
			var viewComponent:ViewComponent = new ViewComponent();
			var mediator:IMediator;

			mediatorMap.mapView(ViewComponent, ViewMediator, null, false, false);
			contextView.addChild(viewComponent);
			mediator = mediatorMap.createMediator(viewComponent);
			Assert.assertNotNull('Mediator should have been created', mediator);
			Assert.assertTrue('Mediator should have been created', mediatorMap.hasMediator(mediator));
			Assert.assertTrue('Mediator should have been created for View Component', mediatorMap.hasMediatorForView(viewComponent));
			mediatorMap.removeMediatorByView(viewComponent);
			Assert.assertFalse("Mediator should not exist", mediatorMap.hasMediator(mediator));
			Assert.assertFalse("View Mediator should not exist", mediatorMap.hasMediatorForView(viewComponent));
		}

		[Test]
		public function mediatorIsMappedAndCreatedAndRemovedWithInjectedNonView():void
		{
			mediatorMap.mapView(NonViewComponent, NonViewMediator, null, false, true);
			var nonViewComponent:NonViewComponent = new NonViewComponent();
			var mediator:IMediator = mediatorMap.createMediator(nonViewComponent);
			var exactMediator:NonViewMediator = mediator as NonViewMediator;
			Assert.assertNotNull('Mediator should have been created', mediator);
			Assert.assertTrue('Mediator should have been created of the exact desired class', mediator is NonViewMediator);
			Assert.assertTrue('Mediator should have been created for View Component', mediatorMap.hasMediatorForView(nonViewComponent));
			Assert.assertNotNull('View Component should have been injected into Mediator', exactMediator.nonView);
			Assert.assertTrue('View Component injected should match the desired class type', exactMediator.nonView is NonViewComponent);
			mediatorMap.removeMediatorByView(nonViewComponent);
			Assert.assertFalse("Mediator should not exist", mediatorMap.hasMediator(exactMediator));
			Assert.assertFalse("View Mediator should not exist", mediatorMap.hasMediatorForView(nonViewComponent));
		}

		[Test]
		public function mediatorIsMappedAndCreatedWithInjectedNonView():void
		{
			mediatorMap.mapView(NonViewComponent, NonViewMediator, null, false, false);
			var nonViewComponent:NonViewComponent = new NonViewComponent();
			var mediator:IMediator = mediatorMap.createMediator(nonViewComponent);
			var exactMediator:NonViewMediator = mediator as NonViewMediator;
			Assert.assertNotNull('Mediator should have been created', mediator);
			Assert.assertTrue('Mediator should have been created of the exact desired class', mediator is NonViewMediator);
			Assert.assertTrue('Mediator should have been created for View Component', mediatorMap.hasMediatorForView(nonViewComponent));
			Assert.assertNotNull('View Component should have been injected into Mediator', exactMediator.nonView);
			Assert.assertTrue('View Component injected should match the desired class type', exactMediator.nonView is NonViewComponent);
		}

		[Test]
		public function mediatorIsMappedAndCreatedWithInjectedNonViewAndAutoRemoveWithoutError():void
		{
			mediatorMap.mapView(NonViewComponent, NonViewMediator, null, false, true);
			var nonViewComponent:NonViewComponent = new NonViewComponent();
			var mediator:IMediator = mediatorMap.createMediator(nonViewComponent);
			var exactMediator:NonViewMediator = mediator as NonViewMediator;
			Assert.assertNotNull('Mediator should have been created', mediator);
			Assert.assertTrue('Mediator should have been created of the exact desired class', mediator is NonViewMediator);
			Assert.assertTrue('Mediator should have been created for View Component', mediatorMap.hasMediatorForView(nonViewComponent));
			Assert.assertNotNull('View Component should have been injected into Mediator', exactMediator.nonView);
			Assert.assertTrue('View Component injected should match the desired class type', exactMediator.nonView is NonViewComponent);
		}

		[Test]
		public function unmapView():void
		{
			mediatorMap.mapView(ViewComponent, ViewMediator);
			mediatorMap.unmapView(ViewComponent);
			var viewComponent:ViewComponent = new ViewComponent();
			contextView.addChild(viewComponent);
			var hasMediator:Boolean = mediatorMap.hasMediatorForView(viewComponent);
			var hasMapping:Boolean = mediatorMap.hasMapping(ViewComponent);
			Assert.assertFalse('Mediator should NOT have been created for View Component', hasMediator);
			Assert.assertFalse('View mapping should NOT exist for View Component', hasMapping);
		}


		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function delayFurther(event:Event, data:Object):void
		{
			Async.handleEvent(this, data.dispatcher, Event.ENTER_FRAME, data.method, 500, data);
			delete data.dispatcher;
			delete data.method;
		}

		private function verifyMediatorRemoval(event:Event, data:Object):void
		{
			var viewComponent:ViewComponent = data.view;
			var mediator:IMediator = data.mediator;
			Assert.assertFalse("Mediator should not exist", mediatorMap.hasMediator(mediator));
			Assert.assertFalse("View Mediator should not exist", mediatorMap.hasMediatorForView(viewComponent));
		}

		private function verifyMediatorSurvival(event:Event, data:Object):void
		{
			var viewComponent:ViewComponent = data.view;
			var mediator:IMediator = data.mediator;
			Assert.assertTrue("Mediator should exist", mediatorMap.hasMediator(mediator));
			Assert.assertTrue("View Mediator should exist", mediatorMap.hasMediatorForView(viewComponent));
		}
	}
}
