/*
 * Copyright (c) 2009 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

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
	import org.swiftsuspenders.Injector;
	
	import org.flexunit.asserts.*;
	import org.flexunit.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.core.allOf;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.hasProperty;
	import org.hamcrest.object.hasProperties;
	
	import org.robotlegs.core.IMediator;
	import org.robotlegs.core.IMediatorMap;
	import org.robotlegs.v2.extensions.mediatorMap.impl.support.TestContextView;
	import org.robotlegs.v2.extensions.mediatorMap.impl.support.TestContextViewMediator;
	import org.robotlegs.v2.extensions.mediatorMap.impl.support.ViewComponent;
	import org.robotlegs.v2.extensions.mediatorMap.impl.support.ViewComponentAdvanced;
	import org.robotlegs.v2.extensions.mediatorMap.impl.support.ViewMediator;
	import org.robotlegs.v2.extensions.mediatorMap.impl.support.ViewMediatorAdvanced;
	
	import org.robotlegs.v2.extensions.mediatorMap.impl.MediatorMap;
	import org.robotlegs.v2.extensions.mediatorMap.utilities.triggers.RL1MediatorTrigger;
	import org.robotlegs.v2.extensions.viewMap.impl.ViewMap;
	import org.robotlegs.v2.extensions.mediatorMap.impl.RL1MediatorMapAdapter;
	import flash.display.DisplayObject;
	import ArgumentError;
	
	public class MediatorMapV1Test
	{
		public static const TEST_EVENT:String = 'testEvent';
		
		protected var contextView:DisplayObjectContainer;
		protected var eventDispatcher:IEventDispatcher;
		protected var commandExecuted:Boolean;
		protected var mediatorMap:RL1MediatorMapAdapter;
		protected var injector:Injector;
		protected var rl2MediatorMap:MediatorMap;
		
		protected var registeredMediators:Array;
		protected var removedMediators:Array;
		
		[Before(ui)]
		public function runBeforeEachTest():void
		{
			contextView = new TestContextView();
			UIImpersonator.addChild(contextView);
			
			contextView.addEventListener(Event.ADDED_TO_STAGE, forwardAddedViewToMediatorMap, true);
			contextView.addEventListener(Event.REMOVED_FROM_STAGE, forwardRemovedViewToMediatorMap, true);
			
			eventDispatcher = new EventDispatcher();
			injector = new Injector();
			
			registeredMediators = new Array();
			removedMediators = new Array();

			injector.map(DisplayObjectContainer).toValue(contextView);
			injector.map(Injector).toValue(injector);
			injector.map(IEventDispatcher).toValue(eventDispatcher);
			injector.map(ViewMap).asSingleton();
			injector.map(Array, 'registered').toValue(registeredMediators);
			injector.map(Array, 'removed').toValue(removedMediators);
			
			rl2MediatorMap = injector.getInstance(MediatorMap);
			rl2MediatorMap.loadTrigger(new RL1MediatorTrigger(false));
			
			injector.map(MediatorMap).toValue(rl2MediatorMap);
			
			mediatorMap = injector.getInstance(RL1MediatorMapAdapter);
			
			injector.map(IMediatorMap).toValue(mediatorMap);
			
		}
		
		[After(ui)]
		public function runAfterEachTest():void
		{
			UIImpersonator.removeAllChildren();
		}
		      
		
		[Test(async, timeout='100') ]
		public function mediatorIsMappedAndCreatedForView():void
		{
			mediatorMap.mapView(ViewComponent, ViewMediator, null);
			var viewComponent:ViewComponent = new ViewComponent();
			contextView.addChild(viewComponent);
			
			Async.handleEvent(this, contextView, Event.ENTER_FRAME, verifyMediatorCreation, 500, {view: viewComponent});
		}
		
		[Test(async, timeout='100') ]
		public function mediatorIsMappedAndCreatedWithInjectViewAsClass():void {
			mediatorMap.mapView(ViewComponent, ViewMediator, ViewComponent);
			var viewComponent:ViewComponent = new ViewComponent();
			contextView.addChild(viewComponent);
			
			Async.handleEvent(this, contextView, Event.ENTER_FRAME, verifyMediatorCreation, 500, {view: viewComponent});
		}
		
		[Test(async, timeout='100') ]
		public function mediatorIsMappedAndCreatedWithInjectViewAsArrayOfSameClass():void {
			mediatorMap.mapView(ViewComponent, ViewMediator, [ViewComponent]);
			var viewComponent:ViewComponent = new ViewComponent();
			contextView.addChild(viewComponent);
			
			Async.handleEvent(this, contextView, Event.ENTER_FRAME, verifyMediatorCreation, 500, {view: viewComponent});
		}
		
		[Test(async, timeout='100') ]
		public function mediatorIsMappedAndCreatedWithInjectViewAsArrayOfRelatedClass():void {
			mediatorMap.mapView(ViewComponentAdvanced, ViewMediatorAdvanced, [ViewComponent, ViewComponentAdvanced]);
			var viewComponentAdvanced:ViewComponentAdvanced = new ViewComponentAdvanced();
			contextView.addChild(viewComponentAdvanced);
			
			const expectedProperties:Object = {	'view':viewComponentAdvanced, 
												'viewAdvanced':viewComponentAdvanced };
			
			Async.handleEvent(this, contextView, Event.ENTER_FRAME, verifyMediatorCreation, 500, expectedProperties);
			
		}
		
		[Test(async, timeout='100') ]
		public function mediatorIsMappedAddedAndRemoved():void
		{
			var viewComponent:ViewComponent = new ViewComponent();

			mediatorMap.mapView(ViewComponent, ViewMediator, null);
			contextView.addChild(viewComponent);
			contextView.removeChild(viewComponent);
			
			Async.handleEvent(this, contextView, Event.ENTER_FRAME, verifyMediatorRemoval, 500, {view: viewComponent});
		}
		
		[Test(async, timeout='100') ]
		public function mediatorIsMappedAddedByView():void
		{
			var viewComponent:ViewComponent = new ViewComponent();
			
			contextView.removeEventListener(Event.ADDED_TO_STAGE, forwardAddedViewToMediatorMap, true);
			
			mediatorMap.mapView(ViewComponent, ViewMediator, null);
			
			contextView.addChild(viewComponent);
			
			mediatorMap.createMediator(viewComponent);
			
			Async.handleEvent(this, contextView, Event.ENTER_FRAME, verifyMediatorCreation, 500, {view: viewComponent});
		}
		
		[Test(async, timeout='100') ]
		public function mediatorIsMappedAddedAndRemovedByView():void
		{
			var viewComponent:ViewComponent = new ViewComponent();
			
			contextView.removeEventListener(Event.ADDED_TO_STAGE, forwardAddedViewToMediatorMap, true);
			contextView.removeEventListener(Event.REMOVED_FROM_STAGE, forwardRemovedViewToMediatorMap, true);
			
			mediatorMap.mapView(ViewComponent, ViewMediator, null);
			contextView.addChild(viewComponent);
			
			mediatorMap.createMediator(viewComponent);
			
			contextView.removeChild(viewComponent);
			
			mediatorMap.removeMediatorByView(viewComponent);

			Async.handleEvent(this, contextView, Event.ENTER_FRAME, verifyMediatorRemoval, 500, {view: viewComponent});
		}
				
		[Test(expects='ArgumentError')]
		public function mappingViewWithAutoCreateSetFalseThrowsError():void
		{
			mediatorMap.mapView(ViewComponent, ViewMediator, null, false, true);
		}
		
		[Test(expects='ArgumentError')]
		public function mappingViewWithAutoRemoveSetFalseThrowsError():void
		{
			mediatorMap.mapView(ViewComponent, ViewMediator, null, true, false);
		}
		
		[Test(async, timeout='100') ]
		public function contextViewMediatorIsCreatedWhenMapped():void
		{
			mediatorMap.mapView( TestContextView, TestContextViewMediator );
			Async.handleEvent(this, contextView, Event.ENTER_FRAME, verifyMediatorCreation, 500, {view: contextView});
		}
		
		[Test]
		public function after_mapView_hasMapping_is_true():void
		{
			mediatorMap.mapView(ViewComponent, ViewMediator);
			assertTrue(mediatorMap.hasMapping(ViewComponent));
		}
		
		[Test]
		public function after_map_and_unmapView_hasMapping_is_false():void
		{
			mediatorMap.mapView(ViewComponent, ViewMediator);
			mediatorMap.unmapView(ViewComponent);
			assertFalse(mediatorMap.hasMapping(ViewComponent));
		}
		
		[Test(async, timeout='100') ]
		public function after_unmapView_mediator_is_not_created():void
		{
			mediatorMap.mapView(ViewComponent, ViewMediator);
			mediatorMap.unmapView(ViewComponent);
			var viewComponent:ViewComponent = new ViewComponent();
			contextView.addChild(viewComponent);
			
			Async.handleEvent(this, contextView, Event.ENTER_FRAME, verifyNoMediatorCreation, 500, {});
		}
		
		// TODO
		
		// REPEAT TESTS USING STRING INSTEAD OF CLASS
		
		// TESTS FOR METHODS THAT RETURN AN INSTANCE
		
		// ERRORS WHERE METHODS RETURN AMBIGUOUS RESULTS
		
		private function verifyMediatorCreation(event:Event, data:Object):void
		{
			assertThat(registeredMediators, array(hasProperties(data)) );
		}
		
		private function verifyNoMediatorCreation(event:Event, data:Object):void
		{
			assertEquals(0, registeredMediators.length);
		}
		
		private function verifyMediatorRemoval(event:Event, data:Object):void
		{
			assertThat(removedMediators, array(hasProperties(data)) );
		}
		
		protected function forwardAddedViewToMediatorMap(e:Event):void
		{
			var view:DisplayObject = e.target as DisplayObject;
			rl2MediatorMap.processView(view, null);
		}	
		
		protected function forwardRemovedViewToMediatorMap(e:Event):void
		{
			var view:DisplayObject = e.target as DisplayObject;
			rl2MediatorMap.releaseView(view);
		}
	}
}