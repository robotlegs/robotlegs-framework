/*
 * Copyright (c) 2009 the original author or authors
 *
 * Permission is hereby granted to use, modify, and distribute this file
 * in accordance with the terms of the license agreement accompanying it.
 */

package robotlegs.bender.extensions.mediatorMap
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
	import robotlegs.bender.extensions.mediatorMap.impl.support.TestContextView;
	import robotlegs.bender.extensions.mediatorMap.impl.support.TestContextViewMediator;
	import robotlegs.bender.extensions.mediatorMap.impl.support.ViewComponent;
	import robotlegs.bender.extensions.mediatorMap.impl.support.ViewComponentAdvanced;
	import robotlegs.bender.extensions.mediatorMap.impl.support.ViewMediator;
	import robotlegs.bender.extensions.mediatorMap.impl.support.ViewMediatorAdvanced;

	import robotlegs.bender.extensions.mediatorMap.impl.MediatorMap;
	import robotlegs.bender.extensions.mediatorMap.utilities.triggers.RL1MediatorTrigger;
	import robotlegs.bender.extensions.viewMap.impl.ViewMap;
	import robotlegs.bender.extensions.mediatorMap.impl.RL1MediatorMapAdapter;
	import flash.display.DisplayObject;
	import ArgumentError;
	import robotlegs.bender.extensions.mediatorMap.utilities.triggers.support.RL1Mediator;

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

		[Test]
		public function get_contextView():void
		{
			assertEquals(contextView, mediatorMap.contextView);
		}

		[Test(async, timeout='100') ]
		public function mediator_is_created_for_mapped_view():void
		{
			mediatorMap.mapView(ViewComponent, ViewMediator, null);
			var viewComponent:ViewComponent = new ViewComponent();
			contextView.addChild(viewComponent);

			Async.handleEvent(this, contextView, Event.ENTER_FRAME, verifyMediatorCreation, 500, {view: viewComponent});
		}

		[Test(async, timeout='100') ]
		public function injectViewAs_sameclass_mediator_is_created_and_views_injected():void {
			mediatorMap.mapView(ViewComponent, ViewMediator, ViewComponent);
			var viewComponent:ViewComponent = new ViewComponent();
			contextView.addChild(viewComponent);

			Async.handleEvent(this, contextView, Event.ENTER_FRAME, verifyMediatorCreation, 500, {view: viewComponent});
		}

		[Test(async, timeout='100') ]
		public function injectViewAs_array_of_sameclass_mediator_is_created_and_views_injected():void {
			mediatorMap.mapView(ViewComponent, ViewMediator, [ViewComponent]);
			var viewComponent:ViewComponent = new ViewComponent();
			contextView.addChild(viewComponent);

			Async.handleEvent(this, contextView, Event.ENTER_FRAME, verifyMediatorCreation, 500, {view: viewComponent});
		}

		[Test(async, timeout='100') ]
		public function injectViewAs_array_of_related_classes_mediator_is_created_and_views_injected():void {
			mediatorMap.mapView(ViewComponentAdvanced, ViewMediatorAdvanced, [ViewComponent, ViewComponentAdvanced]);
			var viewComponentAdvanced:ViewComponentAdvanced = new ViewComponentAdvanced();
			contextView.addChild(viewComponentAdvanced);

			const expectedProperties:Object = {	'view':viewComponentAdvanced,
												'viewAdvanced':viewComponentAdvanced };

			Async.handleEvent(this, contextView, Event.ENTER_FRAME, verifyMediatorCreation, 500, expectedProperties);

		}

		[Test(async, timeout='100') ]
		public function mediator_is_removed():void
		{
			var viewComponent:ViewComponent = new ViewComponent();

			mediatorMap.mapView(ViewComponent, ViewMediator, null);
			contextView.addChild(viewComponent);
			contextView.removeChild(viewComponent);

			Async.handleEvent(this, contextView, Event.ENTER_FRAME, verifyMediatorRemoval, 500, {view: viewComponent});
		}

		[Test(async, timeout='100') ]
		public function createMediator_creates_mediator():void
		{
			var viewComponent:ViewComponent = new ViewComponent();

			contextView.removeEventListener(Event.ADDED_TO_STAGE, forwardAddedViewToMediatorMap, true);

			mediatorMap.mapView(ViewComponent, ViewMediator, null);

			contextView.addChild(viewComponent);

			mediatorMap.createMediator(viewComponent);

			Async.handleEvent(this, contextView, Event.ENTER_FRAME, verifyMediatorCreation, 500, {view: viewComponent});
		}

		[Test(async, timeout='100') ]
		public function removeMediator_removes_mediator():void
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

		[Test]
		public function create_mediator_returns_correct_mediator():void
		{
			var viewComponent:ViewComponent = new ViewComponent();

			contextView.removeEventListener(Event.ADDED_TO_STAGE, forwardAddedViewToMediatorMap, true);
			contextView.removeEventListener(Event.REMOVED_FROM_STAGE, forwardRemovedViewToMediatorMap, true);

			mediatorMap.mapView(ViewComponent, ViewMediator, null);
			contextView.addChild(viewComponent);

			const mediator:IMediator = mediatorMap.createMediator(viewComponent);

			assertThat(mediator.getViewComponent, viewComponent);
		}

		[Test]
		public function remove_by_view_returns_correct_mediator():void
		{
			var viewComponent:ViewComponent = new ViewComponent();

			contextView.removeEventListener(Event.ADDED_TO_STAGE, forwardAddedViewToMediatorMap, true);
			contextView.removeEventListener(Event.REMOVED_FROM_STAGE, forwardRemovedViewToMediatorMap, true);

			mediatorMap.mapView(ViewComponent, ViewMediator, null);
			contextView.addChild(viewComponent);

			mediatorMap.createMediator(viewComponent);

			contextView.removeChild(viewComponent);

			const mediator:IMediator = mediatorMap.removeMediatorByView(viewComponent);

			assertThat(mediator.getViewComponent, viewComponent);
		}

		[Test(expects='ArgumentError')]
		public function mapping_with_autocreate_false_throws_error():void
		{
			mediatorMap.mapView(ViewComponent, ViewMediator, null, false, true);
		}

		[Test(expects='ArgumentError')]
		public function mapping_with_autoremove_false_throws_error():void
		{
			mediatorMap.mapView(ViewComponent, ViewMediator, null, true, false);
		}

		[Test(async, timeout='100') ]
		public function contextView_mediator_is_created_immediately_when_mapped():void
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

		// REPEAT TESTS USING STRING INSTEAD OF CLASS

		[Test(async, timeout='100') ]
		public function using_string_mapping_mediator_is_created_for_mapped_view():void
		{
			mediatorMap.mapView('robotlegs.bender.extensions.mediatorMap.impl.support.ViewComponent', ViewMediator, null);
			var viewComponent:ViewComponent = new ViewComponent();
			contextView.addChild(viewComponent);

			Async.handleEvent(this, contextView, Event.ENTER_FRAME, verifyMediatorCreation, 500, {view: viewComponent});
		}

		[Test(async, timeout='100') ]
		public function using_string_mapping_mediator_is_removed():void
		{
			var viewComponent:ViewComponent = new ViewComponent();

			mediatorMap.mapView('robotlegs.bender.extensions.mediatorMap.impl.support.ViewComponent', ViewMediator, null);
			contextView.addChild(viewComponent);
			contextView.removeChild(viewComponent);

			Async.handleEvent(this, contextView, Event.ENTER_FRAME, verifyMediatorRemoval, 500, {view: viewComponent});
		}

		[Test(async, timeout='100') ]
		public function using_string_after_unmapView_mediator_is_not_created():void
		{
			mediatorMap.mapView('robotlegs.bender.extensions.mediatorMap.impl.support.ViewComponent', ViewMediator);
			mediatorMap.unmapView('robotlegs.bender.extensions.mediatorMap.impl.support.ViewComponent');
			var viewComponent:ViewComponent = new ViewComponent();
			contextView.addChild(viewComponent);

			Async.handleEvent(this, contextView, Event.ENTER_FRAME, verifyNoMediatorCreation, 500, {});
		}

		[Test]
		public function using_string_after_mapView_hasMapping_is_true():void
		{
			mediatorMap.mapView(ViewComponent, ViewMediator);
			assertTrue(mediatorMap.hasMapping('robotlegs.bender.extensions.mediatorMap.impl.support.ViewComponent'));
		}

		// TESTS FOR METHODS THAT RETURN AN INSTANCE

		[Test]
		public function retrieveMediator_gets_correct_mediator_if_there_is_only_one():void
		{
			mediatorMap.mapView(ViewComponent, ViewMediator);

			var viewComponent:ViewComponent = new ViewComponent();
			contextView.addChild(viewComponent);

			assertThat(mediatorMap.retrieveMediator(viewComponent), instanceOf(ViewMediator) );
		}

		[Test]
		public function hasMediatorForView_is_true_for_mediated_view_instance():void
		{
			mediatorMap.mapView(ViewComponent, ViewMediator);

			var viewComponent:ViewComponent = new ViewComponent();
			contextView.addChild(viewComponent);

			assertTrue(mediatorMap.hasMediatorForView(viewComponent));
		}

		[Test]
		public function hasMediatorForView_is_false_for_unmediated_view_instance():void
		{
			mediatorMap.mapView(ViewComponent, ViewMediator);

			var viewComponent:ViewComponent = new ViewComponent();
			contextView.addChild(viewComponent);

			var otherViewComponent:ViewComponent = new ViewComponent();

			assertFalse(mediatorMap.hasMediatorForView(otherViewComponent));
		}

		[Test]
		public function hasMediator_is_true_for_mediated_view_instance():void
		{
			mediatorMap.mapView(ViewComponent, ViewMediator);

			var viewComponent:ViewComponent = new ViewComponent();
			contextView.addChild(viewComponent);

			var mediator:IMediator = mediatorMap.retrieveMediator(viewComponent) as IMediator;

			assertTrue(mediatorMap.hasMediator(mediator));
		}

		[Test]
		public function hasMediator_is_false_for_unmediated_view_instance():void
		{
			mediatorMap.mapView(ViewComponent, ViewMediator);

			var viewComponent:ViewComponent = new ViewComponent();
			contextView.addChild(viewComponent);

			var mediator:IMediator = new RL1Mediator();

			assertFalse(mediatorMap.hasMediator(mediator));
		}

		// ERRORS WHERE METHODS RETURN AMBIGUOUS RESULTS

		[Test(expects='Error')]
		public function retrieveMediator_thows_error_if_there_is_more_than_one_mediator():void
		{
			mediatorMap.mapView(ViewComponent, ViewMediator);
			mediatorMap.mapView(ViewComponent, RL1Mediator);

			var viewComponent:ViewComponent = new ViewComponent();
			contextView.addChild(viewComponent);

			mediatorMap.retrieveMediator(viewComponent);
		}

		[Test(expects='Error')]
		public function registerMediator_throws_error():void
		{
			mediatorMap.registerMediator(new ViewComponent(), new ViewMediator());
		}

		[Test(expects='Error')]
		public function removeMediator_throws_error():void
		{
			mediatorMap.removeMediator(new ViewMediator());
		}

		[Test(expects="ArgumentError")]
		public function setting_enabled_to_false_throws_error():void
		{
			mediatorMap.enabled = false;
		}

		[Test]
		public function enabled_always_returns_true():void
		{
			assertTrue(mediatorMap.enabled);
			try
			{
				mediatorMap.enabled = false;
			}
			catch (e:Error)
			{

			}
			assertTrue(mediatorMap.enabled);
		}

		// PRIVATE

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