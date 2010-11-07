/*
 * Copyright (c) 2009 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.base
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
	import org.robotlegs.mvcs.support.TestContextView;
	import org.robotlegs.mvcs.support.TestContextViewMediator;
	import org.robotlegs.mvcs.support.ViewComponent;
	import org.robotlegs.mvcs.support.ViewComponentAdvanced;
	import org.robotlegs.mvcs.support.ViewMediator;
	import org.robotlegs.mvcs.support.ViewMediatorAdvanced;
	
	public class MediatorMapTests
	{
		public static const TEST_EVENT:String = 'testEvent';
		
		protected var contextView:DisplayObjectContainer;
		protected var eventDispatcher:IEventDispatcher;
		protected var commandExecuted:Boolean;
		protected var mediatorMap:MediatorMap;
		protected var injector:IInjector;
		protected var reflector:IReflector;
		protected var eventMap:IEventMap;
		
		[BeforeClass]
		public static function runBeforeEntireSuite():void
		{
		}
		
		[AfterClass]
		public static function runAfterEntireSuite():void
		{
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
		
		[After(ui)]
		public function runAfterEachTest():void
		{
			UIImpersonator.removeAllChildren();
			injector.unmap(IMediatorMap);
		}
		
		[Test]
		public function mediatorIsMappedAndCreatedForView():void
		{
			mediatorMap.mapView(ViewComponent, ViewMediator, null, false, false);
			var viewComponent:ViewComponent = new ViewComponent();
			contextView.addChild(viewComponent);
			var mediator:IMediator = mediatorMap.createMediator(viewComponent);
			var hasMapping:Boolean = mediatorMap.hasMapping(ViewComponent);
			Assert.assertNotNull('Mediator should have been created ', mediator);
			Assert.assertTrue('Mediator should have been created for View Component', mediatorMap.hasMediatorForView(viewComponent));
			Assert.assertTrue('View mapping should exist for View Component', hasMapping);
		}
		
		[Test]
		public function mediatorIsMappedAndCreatedWithInjectViewAsClass():void {
			mediatorMap.mapView(ViewComponent, ViewMediator, ViewComponent, false, false);
			var viewComponent:ViewComponent = new ViewComponent();
			contextView.addChild(viewComponent);
			var mediator:IMediator = mediatorMap.createMediator(viewComponent);
			var exactMediator:ViewMediator = mediator as ViewMediator;
			Assert.assertNotNull('Mediator should have been created', mediator);
			Assert.assertTrue('Mediator should have been created of the exact desired class', mediator is ViewMediator);
			Assert.assertTrue('Mediator should have been created for View Component', mediatorMap.hasMediatorForView(viewComponent));
			Assert.assertNotNull('View Component should have been injected into Mediator', exactMediator.view);
			Assert.assertTrue('View Component injected should match the desired class type', exactMediator.view is ViewComponent);
		}
		
		[Test]
		public function mediatorIsMappedAndCreatedWithInjectViewAsArrayOfSameClass():void {
			mediatorMap.mapView(ViewComponent, ViewMediator, [ViewComponent], false, false);
			var viewComponent:ViewComponent = new ViewComponent();
			contextView.addChild(viewComponent);
			var mediator:IMediator = mediatorMap.createMediator(viewComponent);
			var exactMediator:ViewMediator = mediator as ViewMediator;
			Assert.assertNotNull('Mediator should have been created', mediator);
			Assert.assertTrue('Mediator should have been created of the exact desired class', mediator is ViewMediator);
			Assert.assertTrue('Mediator should have been created for View Component', mediatorMap.hasMediatorForView(viewComponent));
			Assert.assertNotNull('View Component should have been injected into Mediator', exactMediator.view);
			Assert.assertTrue('View Component injected should match the desired class type', exactMediator.view is ViewComponent);
		}
		
		[Test]
		public function mediatorIsMappedAndCreatedWithInjectViewAsArrayOfRelatedClass():void {
			mediatorMap.mapView(ViewComponentAdvanced, ViewMediatorAdvanced, [ViewComponent, ViewComponentAdvanced], false, false);
			var viewComponentAdvanced:ViewComponentAdvanced = new ViewComponentAdvanced();
			contextView.addChild(viewComponentAdvanced);
			var mediator:IMediator = mediatorMap.createMediator(viewComponentAdvanced);
			var exactMediator:ViewMediatorAdvanced = mediator as ViewMediatorAdvanced;
			Assert.assertNotNull('Mediator should have been created', mediator);
			Assert.assertTrue('Mediator should have been created of the exact desired class', mediator is ViewMediatorAdvanced);
			Assert.assertTrue('Mediator should have been created for View Component', mediatorMap.hasMediatorForView(viewComponentAdvanced));
			Assert.assertNotNull('First Class in the "injectViewAs" array should have been injected into Mediator', exactMediator.view);
			Assert.assertNotNull('Second Class in the "injectViewAs" array should have been injected into Mediator', exactMediator.viewAdvanced);
			Assert.assertTrue('First Class injected via the "injectViewAs" array should match the desired class type', exactMediator.view is ViewComponent);
			Assert.assertTrue('Second Class injected via the "injectViewAs" array should match the desired class type', exactMediator.viewAdvanced is ViewComponentAdvanced);
		}
		
		
		[Test]
		public function mediatorIsMappedAddedAndRemoved():void
		{
			var viewComponent:ViewComponent = new ViewComponent();
			var mediator:IMediator;
			
			mediatorMap.mapView(ViewComponent, ViewMediator, null, false, false);
			contextView.addChild(viewComponent);
			mediator = mediatorMap.createMediator(viewComponent);
			Assert.assertNotNull('Mediator should have been created', mediator);
			Assert.assertTrue('Mediator should have been created', mediatorMap.hasMediator(mediator));
			Assert.assertTrue('Mediator should have been created for View Component', mediatorMap.hasMediatorForView(viewComponent));
			mediatorMap.removeMediator(mediator);
			Assert.assertFalse("Mediator Should Not Exist", mediatorMap.hasMediator(mediator));
			Assert.assertFalse("View Mediator Should Not Exist", mediatorMap.hasMediatorForView(viewComponent));
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
		public function autoRegister():void
		{
			mediatorMap.mapView(ViewComponent, ViewMediator, null, true, true);
			var viewComponent:ViewComponent = new ViewComponent();
			contextView.addChild(viewComponent);
			Assert.assertTrue('Mediator should have been created for View Component', mediatorMap.hasMediatorForView(viewComponent));
		}
		
		[Test(async, timeout='500')]
		public function mediatorIsKeptDuringReparenting():void
		{
			var viewComponent:ViewComponent = new ViewComponent();
			var mediator:IMediator;
			
			mediatorMap.mapView(ViewComponent, ViewMediator, null, false, true);
			contextView.addChild(viewComponent);
			mediator = mediatorMap.createMediator(viewComponent);
			Assert.assertNotNull('Mediator should have been created', mediator);
			Assert.assertTrue('Mediator should have been created', mediatorMap.hasMediator(mediator));
			Assert.assertTrue('Mediator should have been created for View Component', mediatorMap.hasMediatorForView(viewComponent));
			var container:UIComponent = new UIComponent();
			contextView.addChild(container);
			container.addChild(viewComponent);
			
			Async.handleEvent(this, contextView, Event.ENTER_FRAME, delayFurther, 500, {dispatcher: contextView, method: verifyMediatorSurvival, view: viewComponent, mediator: mediator});
		}
		
		private function verifyMediatorSurvival(event:Event, data:Object):void
		{
			var viewComponent:ViewComponent = data.view;
			var mediator:IMediator = data.mediator;
			Assert.assertTrue("Mediator should exist", mediatorMap.hasMediator(mediator));
			Assert.assertTrue("View Mediator should exist", mediatorMap.hasMediatorForView(viewComponent));
		}
		
		[Test(async, timeout='500')]
		public function mediatorIsRemovedWithView():void
		{
			var viewComponent:ViewComponent = new ViewComponent();
			var mediator:IMediator;
			
			mediatorMap.mapView(ViewComponent, ViewMediator, null, false, true);
			contextView.addChild(viewComponent);
			mediator = mediatorMap.createMediator(viewComponent);
			Assert.assertNotNull('Mediator should have been created', mediator);
			Assert.assertTrue('Mediator should have been created', mediatorMap.hasMediator(mediator));
			Assert.assertTrue('Mediator should have been created for View Component', mediatorMap.hasMediatorForView(viewComponent));
			
			contextView.removeChild(viewComponent);
			Async.handleEvent(this, contextView, Event.ENTER_FRAME, delayFurther, 500, {dispatcher: contextView, method: verifyMediatorRemoval, view: viewComponent, mediator: mediator});
		}
		
		private function verifyMediatorRemoval(event:Event, data:Object):void
		{
			var viewComponent:ViewComponent = data.view;
			var mediator:IMediator = data.mediator;
			Assert.assertFalse("Mediator should not exist", mediatorMap.hasMediator(mediator));
			Assert.assertFalse("View Mediator should not exist", mediatorMap.hasMediatorForView(viewComponent));
		}
		
		private function delayFurther(event:Event, data:Object):void
		{
			Async.handleEvent(this, data.dispatcher, Event.ENTER_FRAME, data.method, 500, data);
			delete data.dispatcher;
			delete data.method;
		}
		
		[Test]
		public function contextViewMediatorIsCreatedWhenMapped():void
		{
			mediatorMap.mapView( TestContextView, TestContextViewMediator );
			Assert.assertTrue('Mediator should have been created for contextView', mediatorMap.hasMediatorForView(contextView));
		}
		
		[Test]
		public function contextViewMediatorIsNotCreatedWhenMappedAndAutoCreateIsFalse():void
		{
			mediatorMap.mapView( TestContextView, TestContextViewMediator, null, false );
			Assert.assertFalse('Mediator should NOT have been created for contextView', mediatorMap.hasMediatorForView(contextView));
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
		
		[Test]
		public function autoRegisterUnregisterRegister():void
		{
			var viewComponent:ViewComponent = new ViewComponent();
			
			mediatorMap.mapView(ViewComponent, ViewMediator, null, true, true);
			mediatorMap.unmapView(ViewComponent);
			contextView.addChild(viewComponent);
			Assert.assertFalse('Mediator should NOT have been created for View Component', mediatorMap.hasMediatorForView(viewComponent));
			contextView.removeChild(viewComponent);
			
			mediatorMap.mapView(ViewComponent, ViewMediator, null, true, true);
			contextView.addChild(viewComponent);
			Assert.assertTrue('Mediator should have been created for View Component', mediatorMap.hasMediatorForView(viewComponent));
		}
	}
}
