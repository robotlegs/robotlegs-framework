//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import org.flexunit.Assert;
	import org.flexunit.asserts.*;
	import org.flexunit.asserts.assertEqualsVectorsIgnoringOrder;
	import org.flexunit.async.Async;
	import org.robotlegs.v2.core.impl.TypeMatcher;
	import org.robotlegs.v2.extensions.guardsAndHooks.impl.GuardsProcessor;
	import org.robotlegs.v2.extensions.guardsAndHooks.impl.HooksProcessor;
	import org.robotlegs.v2.extensions.mediatorMap.impl.MediatorMap;
	import org.robotlegs.v2.extensions.mediatorMap.impl.support.MediatorWatcher;
	import org.robotlegs.v2.extensions.mediatorMap.support.DuckTypedRL1MediatorTrigger;
	import org.robotlegs.v2.extensions.mediatorMap.utilities.triggers.DuckTypedMediatorTrigger;
	import org.robotlegs.v2.extensions.mediatorMap.utilities.triggers.RL2MediatorTrigger;
	import org.robotlegs.v2.extensions.viewManager.api.IViewHandler;
	import org.robotlegs.v2.extensions.viewManager.api.ViewHandlerEvent;
	import org.swiftsuspenders.Injector;

	public class MediatorMapTest
	{

		private var injector:Injector;

		private var instance:MediatorMap;

		private var mediatorWatcher:MediatorWatcher;

		[Before]
		public function setUp():void
		{
			injector = new Injector();

			instance = new MediatorMap();
			instance.hooksProcessor = new HooksProcessor();
			instance.guardsProcessor = new GuardsProcessor();
			instance.injector = injector;
			instance.hooksProcessor = new HooksProcessor();
			instance.guardsProcessor = new GuardsProcessor();
			instance.loadTrigger(new DuckTypedMediatorTrigger(false));

			mediatorWatcher = new MediatorWatcher();
			injector.map(MediatorWatcher).toValue(mediatorWatcher);
		}

		[After]
		public function tearDown():void
		{
			instance = null;
		}

		[Test]
		public function a_hook_runs_and_receives_injections_of_view_and_mediator():void
		{
			instance.map(RectangleMediator).toView(Sprite).withHooks(HookWithMediatorAndViewInjectionDrawsRectangle);

			const view:Sprite = new Sprite();

			const expectedViewWidth:Number = 100;
			const expectedViewHeight:Number = 200;

			injector.map(Rectangle).toValue(new Rectangle(0, 0, expectedViewWidth, expectedViewHeight));

			instance.processView(view, null);

			assertEquals(expectedViewWidth, view.width);
			assertEquals(expectedViewHeight, view.height);
		}

		[Test]
		public function can_be_instantiated():void
		{
			assertTrue("instance is MediatorMap", instance is MediatorMap);
		}

		[Test]
		public function create_mediator_instantiates_mediator_for_view_when_mapped():void
		{
			instance.map(ExampleMediator).toView(Sprite);

			instance.mediate(new Sprite());

			var expectedNotifications:Vector.<String> = new <String>['ExampleMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function doesnt_leave_view_and_mediator_mappings_lying_around():void
		{
			instance.map(ExampleMediator).toMatcher(new TypeMatcher().anyOf(MovieClip, Sprite));
			instance.processView(new Sprite(), null);

			assertFalse(injector.satisfies(MovieClip));
			assertFalse(injector.satisfies(Sprite));
			assertFalse(injector.satisfies(ExampleMediator));
		}

		[Test]
		public function handler_creates_mediator_for_view_mapped_by_matcher():void
		{
			instance.map(ExampleDisplayObjectMediator).toMatcher(new TypeMatcher().allOf(DisplayObject));

			instance.processView(new Sprite(), null);

			var expectedNotifications:Vector.<String> = new <String>['ExampleDisplayObjectMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function handler_doesnt_create_mediator_for_wrong_view_mapped_by_matcher():void
		{
			instance.map(ExampleDisplayObjectMediator).toMatcher(new TypeMatcher().allOf(MovieClip));

			instance.processView(new Sprite(), null);

			var expectedNotifications:Vector.<String> = new <String>[];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function handler_instantiates_mediator_for_view_mapped_by_type():void
		{
			instance.map(ExampleMediator).toView(Sprite);

			instance.processView(new Sprite(), null);

			var expectedNotifications:Vector.<String> = new <String>['ExampleMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function hasMapping_returns_false_for_mapped_then_unmapped_mediator_class_by_fromAll():void
		{
			instance.map(ExampleMediator).toView(Sprite);
			instance.map(ExampleDisplayObjectMediator).toView(Sprite);
			instance.unmap(ExampleDisplayObjectMediator).fromAll();

			assertFalse(instance.hasMapping(ExampleDisplayObjectMediator));
		}

		[Test]
		public function hasMapping_returns_false_for_mapped_then_unmapped_mediator_class_by_fromView():void
		{
			instance.map(ExampleMediator).toView(Sprite);
			instance.map(ExampleDisplayObjectMediator).toView(Sprite);
			instance.unmap(ExampleDisplayObjectMediator).fromView(Sprite);

			assertFalse(instance.hasMapping(ExampleDisplayObjectMediator));
		}

		[Test]
		public function hasMapping_returns_false_for_unmapped_mediator_class():void
		{
			instance.map(ExampleMediator).toView(Sprite);

			assertFalse(instance.hasMapping(ExampleDisplayObjectMediator));
		}

		[Test]
		public function hasMapping_returns_true_for_mapped_mediator_class():void
		{
			instance.map(ExampleMediator).toView(Sprite);

			assertTrue(instance.hasMapping(ExampleMediator));
		}

		[Test]
		public function implements_IViewHandler():void
		{
			assertTrue("instance is IViewHandler", instance is IViewHandler);
		}

		[Test(async)]
		public function invalidate_causes_the_configuration_change_event_to_be_dispatched():void
		{
			instance.addEventListener(ViewHandlerEvent.HANDLER_CONFIGURATION_CHANGE,
				Async.asyncHandler(this, benignHandler, 10, null, handleEventTimeout), false, 0, true);

			instance.invalidate();
		}

		[Test]
		public function is_not_interested_if_all_mappings_unmapped_in_one_hit():void
		{
			instance.map(ExampleMediator).toView(Sprite);
			instance.map(ExampleMediator).toView(MovieClip);
			instance.unmap(ExampleMediator).fromAll();

			var interest:uint = instance.processView(new Sprite(), null);
			assertEquals(0, interest);
		}

		[Test]
		public function is_not_interested_if_mapping_is_unmapped_for_matcher():void
		{
			instance.map(ExampleDisplayObjectMediator).toMatcher(new TypeMatcher().allOf(DisplayObject));
			instance.unmap(ExampleDisplayObjectMediator).fromMatcher(new TypeMatcher().allOf(DisplayObject));

			var interest:uint = instance.processView(new Sprite(), null);
			assertEquals(0, interest);
		}

		[Test]
		public function is_not_interested_if_mapping_is_unmapped_for_view_by_fromMatcher():void
		{
			instance.map(ExampleMediator).toView(Sprite);
			instance.unmap(ExampleMediator).fromMatcher(new TypeMatcher().allOf(Sprite));

			var interest:uint = instance.processView(new Sprite(), null);
			assertEquals(0, interest);
		}

		[Test]
		public function is_not_interested_if_mapping_is_unmapped_for_view_by_fromView():void
		{
			instance.map(ExampleMediator).toView(Sprite);
			instance.unmap(ExampleMediator).fromView(Sprite);

			var interest:uint = instance.processView(new Sprite(), null);
			assertEquals(0, interest);
		}

		[Test]
		public function is_still_interested_if_only_one_mapping_of_two_is_unmapped():void
		{
			instance.map(ExampleMediator).toView(Sprite);
			instance.map(ExampleMediator).toView(MovieClip);
			instance.unmap(ExampleMediator).fromMatcher(new TypeMatcher().allOf(MovieClip));

			var interest:uint = instance.processView(new Sprite(), null);
			assertEquals(1, interest);
		}

		[Test]
		public function mediate_instantiates_mediator_for_view_when_matched_to_mapping():void
		{
			instance.map(ExampleMediator).toView(Sprite);

			instance.mediate(new Sprite());

			var expectedNotifications:Vector.<String> = new <String>['ExampleMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function mediate_returns_false_for_view_when_not_matched_to_mapping():void
		{
			instance.map(ExampleMediator).toView(MovieClip);

			assertFalse(instance.mediate(new Sprite()));
		}

		[Test]
		public function mediate_returns_true_for_view_when_matched_to_mapping():void
		{
			instance.map(ExampleMediator).toView(Sprite);

			assertTrue(instance.mediate(new Sprite()));
		}

		[Test]
		public function mediator_is_created_if_guard_allows_it():void
		{
			instance.map(ExampleMediator).toView(Sprite).withGuards(OnlyIfViewHasChildrenGuard);
			const view:Sprite = new Sprite();
			view.addChild(new Sprite());
			instance.processView(view, null);

			var expectedNotifications:Vector.<String> = new <String>['ExampleMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function no_mediator_is_created_if_guard_prevents_it():void
		{
			instance.map(ExampleMediator).toView(Sprite).withGuards(OnlyIfViewHasChildrenGuard);
			const view:Sprite = new Sprite();
			instance.processView(view, null);

			var expectedNotifications:Vector.<String> = new <String>[];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function returns_one_if_handler_interested():void
		{
			instance.map(ExampleMediator).toView(Sprite).withGuards(OnlyIfViewHasChildrenGuard);

			var interest:uint = instance.processView(new Sprite(), null);

			assertEquals(1, interest);
		}

		[Test]
		public function returns_zero_if_handler_not_interested():void
		{
			instance.map(ExampleMediator).toView(MovieClip).withGuards(OnlyIfViewHasChildrenGuard);

			var interest:uint = instance.processView(new Sprite(), null);

			assertEquals(0, interest);
		}

		[Test]
		public function runs_destroy_on_created_mediator_when_handleViewRemoved_runs():void
		{
			instance.map(ExampleMediator).toView(Sprite);

			const view:Sprite = new Sprite();
			instance.processView(view, null);
			instance.releaseView(view);

			var expectedNotifications:Vector.<String> = new <String>['ExampleMediator', 'ExampleMediator destroy'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test(async)]
		public function test_failure_seen():void
		{
			assertTrue(true);
		}

		[Test]
		public function unmediate_cleans_up_mediators():void
		{
			instance.map(ExampleMediator).toView(Sprite);

			const view:Sprite = new Sprite();

			instance.mediate(view);
			instance.unmediate(view);

			var expectedNotifications:Vector.<String> = new <String>['ExampleMediator', 'ExampleMediator destroy'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}
		
		[Test(expects="flash.errors.IllegalOperationError")]
		public function loadTrigger_can_only_be_run_once():void
		{
			instance.loadTrigger(new RL2MediatorTrigger(true));
		}

		protected function handleEventTimeout(o:Object):void
		{
			Assert.fail("The event never fired");
		}

		protected function benignHandler(e:Event, o:Object):void
		{
			// do nothing
		}
	}
}

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Rectangle;
import org.robotlegs.v2.extensions.mediatorMap.impl.support.MediatorWatcher;

class ExampleMediator
{

	[Inject]
	public var mediatorWatcher:MediatorWatcher;

	[Inject]
	public var view:Sprite;

	public function initialize():void
	{
		mediatorWatcher.notify('ExampleMediator');
	}

	public function destroy():void
	{
		mediatorWatcher.notify('ExampleMediator destroy');
	}
}

class ExampleDisplayObjectMediator
{

	[Inject]
	public var mediatorWatcher:MediatorWatcher;

	[Inject]
	public var view:DisplayObject;

	public function initialize():void
	{
		mediatorWatcher.notify('ExampleDisplayObjectMediator');
	}
}

class RectangleMediator
{

	[Inject]
	public var rectangle:Rectangle;

	public function initialize():void
	{

	}
}

class OnlyIfViewHasChildrenGuard
{

	[Inject]
	public var view:Sprite;

	public function approve():Boolean
	{
		return (view.numChildren > 0);
	}
}

class HookWithMediatorAndViewInjectionDrawsRectangle
{

	[Inject]
	public var mediator:RectangleMediator;

	[Inject]
	public var view:Sprite;

	public function hook():void
	{
		const requiredWidth:Number = mediator.rectangle.width;
		const requiredHeight:Number = mediator.rectangle.height;

		view.graphics.drawRect(0, 0, requiredWidth, requiredHeight);
	}
}