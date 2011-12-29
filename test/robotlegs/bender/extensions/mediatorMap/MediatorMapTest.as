//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap
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
	import robotlegs.bender.core.impl.TypeMatcher;
	import robotlegs.bender.extensions.mediatorMap.impl.MediatorMap;
	import robotlegs.bender.extensions.mediatorMap.impl.support.MediatorWatcher;
	import robotlegs.bender.extensions.mediatorMap.utilities.triggers.DuckTypedMediatorTrigger;
	import robotlegs.bender.extensions.mediatorMap.utilities.triggers.RL2MediatorTrigger;
	import robotlegs.bender.extensions.viewManager.api.IViewHandler;
	import robotlegs.bender.extensions.viewManager.api.ViewHandlerEvent;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.viewMap.impl.ViewMap;

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
			instance.injector = injector;

			const viewMap:ViewMap = new ViewMap();
			viewMap.injector = injector;

			instance.viewMap = viewMap;

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
			instance.map(Sprite).toMediator(RectangleMediator).withHooks(HookWithMediatorAndViewInjectionDrawsRectangle);

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
			instance.map(Sprite).toMediator(ExampleMediator);

			instance.mediate(new Sprite());

			var expectedNotifications:Vector.<String> = new <String>['ExampleMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function doesnt_leave_view_and_mediator_mappings_lying_around():void
		{
			instance.mapMatcher(new TypeMatcher().anyOf(MovieClip, Sprite)).toMediator(ExampleMediator);
			instance.processView(new Sprite(), null);

			assertFalse(injector.satisfies(MovieClip));
			assertFalse(injector.satisfies(Sprite));
			assertFalse(injector.satisfies(ExampleMediator));
		}

		[Test]
		public function handler_creates_mediator_for_view_mapped_by_matcher():void
		{
			instance.mapMatcher(new TypeMatcher().allOf(DisplayObject)).toMediator(ExampleDisplayObjectMediator);

			instance.processView(new Sprite(), null);

			var expectedNotifications:Vector.<String> = new <String>['ExampleDisplayObjectMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function handler_doesnt_create_mediator_for_wrong_view_mapped_by_matcher():void
		{
			instance.mapMatcher(new TypeMatcher().allOf(MovieClip)).toMediator(ExampleDisplayObjectMediator);

			instance.processView(new Sprite(), null);

			var expectedNotifications:Vector.<String> = new <String>[];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function handler_instantiates_mediator_for_view_mapped_by_type():void
		{
			instance.map(Sprite).toMediator(ExampleMediator);

			instance.processView(new Sprite(), null);

			var expectedNotifications:Vector.<String> = new <String>['ExampleMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function hasMapping_returns_false_for_mapped_then_unmapped_view_class_by_fromAll():void
		{
			instance.map(Sprite).toMediator(ExampleMediator);
			instance.map(Sprite).toMediator(ExampleDisplayObjectMediator);
			instance.unmap(Sprite).fromAll();

			assertFalse(instance.hasMapping(Sprite));
		}

		[Test]
		public function hasMapping_returns_false_for_mapped_then_unmapped_view_class_by_fromMediator():void
		{
			instance.map(Sprite).toMediator(ExampleMediator);
			instance.map(Sprite).toMediator(ExampleDisplayObjectMediator);
			instance.unmap(Sprite).fromMediator(ExampleDisplayObjectMediator);
			instance.unmap(Sprite).fromMediator(ExampleMediator);

			assertFalse(instance.hasMapping(Sprite));
		}

		[Test]
		public function hasMapping_returns_false_for_unmapped_view_class():void
		{
			instance.map(Sprite).toMediator(ExampleMediator);

			assertFalse(instance.hasMapping(MovieClip));
		}

		[Test]
		public function hasMapping_returns_true_for_mapped_view_class():void
		{
			instance.map(Sprite).toMediator(ExampleMediator);

			assertTrue(instance.hasMapping(Sprite));
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
			instance.map(Sprite).toMediator(ExampleMediator);
			instance.map(Sprite).toMediator(ExampleDisplayObjectMediator);
			instance.unmap(Sprite).fromAll();

			var interest:uint = instance.processView(new Sprite(), null);
			assertEquals(0, interest);
		}

		[Test]
		public function is_not_interested_if_mapping_is_unmapped_for_matcher():void
		{
			instance.mapMatcher(new TypeMatcher().allOf(DisplayObject)).toMediator(ExampleMediator);
			instance.mapMatcher(new TypeMatcher().allOf(DisplayObject)).toMediator(ExampleDisplayObjectMediator);
			instance.unmapMatcher(new TypeMatcher().allOf(DisplayObject)).fromAll();

			var interest:uint = instance.processView(new Sprite(), null);
			assertEquals(0, interest);
		}

		[Test]
		public function is_not_interested_if_mapping_is_unmapped_for_view_by_fromMediator():void
		{
			instance.mapMatcher(new TypeMatcher().allOf(DisplayObject)).toMediator(ExampleMediator);
			instance.unmapMatcher(new TypeMatcher().allOf(DisplayObject)).fromMediator(ExampleMediator);

			var interest:uint = instance.processView(new Sprite(), null);
			assertEquals(0, interest);
		}

		[Test]
		public function is_not_interested_if_mapping_is_unmapped_for_view_by_fromView():void
		{
			instance.map(Sprite).toMediator(ExampleMediator);
			instance.unmap(Sprite).fromMediator(ExampleMediator);

			var interest:uint = instance.processView(new Sprite(), null);
			assertEquals(0, interest);
		}

		[Test]
		public function is_still_interested_if_only_one_mapping_of_two_is_unmapped():void
		{
			instance.map(Sprite).toMediator(ExampleMediator);
			instance.map(Sprite).toMediator(ExampleDisplayObjectMediator);
			instance.unmap(Sprite).fromMediator(ExampleDisplayObjectMediator);

			var interest:uint = instance.processView(new Sprite(), null);
			assertTrue(interest > 0 );
		}

		[Test]
		public function mediate_instantiates_mediator_for_view_when_matched_to_mapping():void
		{
			instance.map(Sprite).toMediator(ExampleMediator);

			instance.mediate(new Sprite());

			var expectedNotifications:Vector.<String> = new <String>['ExampleMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function mediate_returns_false_for_view_when_not_matched_to_mapping():void
		{
			instance.map(MovieClip).toMediator(ExampleMediator);

			assertFalse(instance.mediate(new Sprite()));
		}

		[Test]
		public function mediate_returns_true_for_view_when_matched_to_mapping():void
		{
			instance.map(Sprite).toMediator(ExampleMediator);

			assertTrue(instance.mediate(new Sprite()));
		}

		[Test]
		public function mediator_is_created_if_guard_allows_it():void
		{
			instance.map(Sprite).toMediator(ExampleMediator).withGuards(OnlyIfViewHasChildrenGuard);
			const view:Sprite = new Sprite();
			view.addChild(new Sprite());
			instance.processView(view, null);

			var expectedNotifications:Vector.<String> = new <String>['ExampleMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function no_mediator_is_created_if_guard_prevents_it():void
		{
			instance.map(Sprite).toMediator(ExampleMediator).withGuards(OnlyIfViewHasChildrenGuard);
			const view:Sprite = new Sprite();
			instance.processView(view, null);

			var expectedNotifications:Vector.<String> = new <String>[];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function returns_one_if_handler_interested():void
		{
			instance.map(Sprite).toMediator(ExampleMediator).withGuards(OnlyIfViewHasChildrenGuard);

			var interest:uint = instance.processView(new Sprite(), null);

			assertEquals(1, interest);
		}

		[Test]
		public function returns_zero_if_handler_not_interested():void
		{
			instance.map(MovieClip).toMediator(ExampleMediator).withGuards(OnlyIfViewHasChildrenGuard);

			var interest:uint = instance.processView(new Sprite(), null);

			assertEquals(0, interest);
		}

		[Test]
		public function runs_destroy_on_created_mediator_when_handleViewRemoved_runs():void
		{
			instance.map(Sprite).toMediator(ExampleMediator);

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
			instance.map(Sprite).toMediator(ExampleMediator);

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
import robotlegs.bender.extensions.mediatorMap.impl.support.MediatorWatcher;

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