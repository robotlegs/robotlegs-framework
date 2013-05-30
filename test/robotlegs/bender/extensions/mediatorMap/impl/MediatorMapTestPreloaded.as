//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import org.flexunit.asserts.assertEqualsVectorsIgnoringOrder;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import robotlegs.bender.extensions.matching.TypeMatcher;
	import robotlegs.bender.extensions.mediatorMap.impl.support.MediatorWatcher;
	import robotlegs.bender.extensions.viewManager.api.IViewHandler;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.impl.Context;
	import robotlegs.bender.framework.impl.guardSupport.HappyGuard;

	public class MediatorMapTestPreloaded
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var injector:IInjector;

		private var mediatorMap:MediatorMap;

		private var mediatorWatcher:MediatorWatcher;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function setUp():void
		{
			const context:Context = new Context();
			injector = context.injector;
			mediatorMap = new MediatorMap(context);
			mediatorWatcher = new MediatorWatcher();
			injector.map(MediatorWatcher).toValue(mediatorWatcher);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function a_hook_runs_and_receives_injections_of_view_and_mediator():void
		{
			mediatorMap.map(Sprite).toMediator(RectangleMediator).withHooks(HookWithMediatorAndViewInjectionDrawsRectangle);

			const view:Sprite = new Sprite();

			const expectedViewWidth:Number = 100;
			const expectedViewHeight:Number = 200;

			injector.map(Rectangle).toValue(new Rectangle(0, 0, expectedViewWidth, expectedViewHeight));

			mediatorMap.handleView(view, null);

			assertThat(expectedViewWidth, equalTo(view.width));
			assertThat(expectedViewHeight, equalTo(view.height));
		}

		[Test]
		public function can_be_instantiated():void
		{
			assertThat(mediatorMap is MediatorMap, isTrue());
		}

		[Test]
		public function create_mediator_instantiates_mediator_for_view_when_mapped():void
		{
			mediatorMap.map(Sprite).toMediator(ExampleMediator);

			mediatorMap.handleView(new Sprite(), null);

			const expectedNotifications:Vector.<String> = new <String>['ExampleMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function doesnt_leave_view_and_mediator_mappings_lying_around():void
		{
			mediatorMap.mapMatcher(new TypeMatcher().anyOf(MovieClip, Sprite)).toMediator(ExampleMediator);
			mediatorMap.handleView(new Sprite(), null);

			assertThat(injector.satisfiesDirectly(MovieClip), isFalse());
			assertThat(injector.satisfiesDirectly(Sprite), isFalse());
			assertThat(injector.satisfiesDirectly(ExampleMediator), isFalse());
		}

		[Test]
		public function handler_creates_mediator_for_view_mapped_by_matcher():void
		{
			mediatorMap.mapMatcher(new TypeMatcher().allOf(DisplayObject)).toMediator(ExampleDisplayObjectMediator);

			mediatorMap.handleView(new Sprite(), null);

			const expectedNotifications:Vector.<String> = new <String>['ExampleDisplayObjectMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function handler_doesnt_create_mediator_for_wrong_view_mapped_by_matcher():void
		{
			mediatorMap.mapMatcher(new TypeMatcher().allOf(MovieClip)).toMediator(ExampleDisplayObjectMediator);

			mediatorMap.handleView(new Sprite(), null);

			const expectedNotifications:Vector.<String> = new <String>[];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function handler_instantiates_mediator_for_view_mapped_by_type():void
		{
			mediatorMap.map(Sprite).toMediator(ExampleMediator);

			mediatorMap.handleView(new Sprite(), null);

			const expectedNotifications:Vector.<String> = new <String>['ExampleMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function implements_IViewHandler():void
		{
			assertThat(mediatorMap, instanceOf(IViewHandler));
		}

		[Test]
		public function mediate_instantiates_mediator_for_view_when_matched_to_mapping():void
		{
			mediatorMap.map(Sprite).toMediator(ExampleMediator);

			mediatorMap.mediate(new Sprite());

			const expectedNotifications:Vector.<String> = new <String>['ExampleMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function mediator_is_created_if_guard_allows_it():void
		{
			mediatorMap.map(Sprite).toMediator(ExampleMediator).withGuards(OnlyIfViewHasChildrenGuard);
			const view:Sprite = new Sprite();
			view.addChild(new Sprite());
			mediatorMap.mediate(view);

			const expectedNotifications:Vector.<String> = new <String>['ExampleMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function no_mediator_is_created_if_guard_prevents_it():void
		{
			mediatorMap.map(Sprite).toMediator(ExampleMediator).withGuards(OnlyIfViewHasChildrenGuard);
			const view:Sprite = new Sprite();
			mediatorMap.mediate(view);

			const expectedNotifications:Vector.<String> = new <String>[];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function runs_destroy_on_created_mediator_when_unmediate_runs():void
		{
			mediatorMap.map(Sprite).toMediator(ExampleMediator);

			const view:Sprite = new Sprite();
			mediatorMap.mediate(view);
			mediatorMap.unmediate(view);

			const expectedNotifications:Vector.<String> = new <String>['ExampleMediator', 'ExampleMediator destroy'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function mediator_is_created_for_non_view_object():void
		{
			mediatorMap.map(NotAView).toMediator(NotAViewMediator);
			const notAView:NotAView = new NotAView();
			mediatorMap.mediate(notAView);

			const expectedNotifications:Vector.<String> = new <String>['NotAViewMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function non_view_object_injected_into_mediator_correctly():void
		{
			mediatorMap.map(NotAView).toMediator(NotAViewMediator);
			const notAView:NotAView = new NotAView();
			mediatorMap.mediate(notAView);
			assertThat(notAView.mediatorName, equalTo('NotAViewMediator'));
		}

		[Test]
		public function mediator_is_destroyed_for_non_view_object():void
		{
			mediatorMap.map(NotAView).toMediator(NotAViewMediator);
			const notAView:NotAView = new NotAView();
			mediatorMap.mediate(notAView);
			mediatorMap.unmediate(notAView);

			const expectedNotifications:Vector.<String> = new <String>['NotAViewMediator', 'NotAViewMediator destroy'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function unmediate_cleans_up_mediators():void
		{
			mediatorMap.map(Sprite).toMediator(ExampleMediator);

			const view:Sprite = new Sprite();

			mediatorMap.mediate(view);
			mediatorMap.unmediate(view);

			const expectedNotifications:Vector.<String> = new <String>['ExampleMediator', 'ExampleMediator destroy'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function multiple_mappings_per_matcher_create_mediators():void
		{
			mediatorMap.map(Sprite).toMediator(ExampleMediator);
			mediatorMap.map(Sprite).toMediator(ExampleMediator2);

			mediatorMap.mediate(new Sprite());
			const expectedNotifications:Vector.<String> = new <String>['ExampleMediator', 'ExampleMediator2'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function multiple_mappings_per_matcher_destroy_mediators():void
		{
			mediatorMap.map(Sprite).toMediator(ExampleMediator);
			mediatorMap.map(Sprite).toMediator(ExampleMediator2);

			const view:Sprite = new Sprite();

			mediatorMap.mediate(view);
			mediatorMap.unmediate(view);

			const expectedNotifications:Vector.<String> = new <String>['ExampleMediator', 'ExampleMediator2', 'ExampleMediator destroy', 'ExampleMediator2 destroy'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function only_one_mediator_created_if_identical_mapping_duplicated():void
		{
			mediatorMap.map(Sprite).toMediator(ExampleMediator).withGuards(HappyGuard).withHooks(Alpha50PercentHook);
			mediatorMap.map(Sprite).toMediator(ExampleMediator).withGuards(HappyGuard).withHooks(Alpha50PercentHook);

			mediatorMap.mediate(new Sprite());
			const expectedNotifications:Vector.<String> = new <String>['ExampleMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function removing_a_mapping_that_doesnt_exist_doesnt_throw_an_error():void
		{
			mediatorMap.unmap(Sprite).fromMediator(ExampleMediator);
		}
	}
}

import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.geom.Rectangle;
import robotlegs.bender.extensions.mediatorMap.impl.support.MediatorWatcher;

class ExampleMediator
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var mediatorWatcher:MediatorWatcher;

	[Inject]
	public var view:Sprite;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function initialize():void
	{
		mediatorWatcher.notify('ExampleMediator');
	}

	public function destroy():void
	{
		mediatorWatcher.notify('ExampleMediator destroy');
	}
}

class ExampleMediator2
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var mediatorWatcher:MediatorWatcher;

	[Inject]
	public var view:Sprite;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function initialize():void
	{
		mediatorWatcher.notify('ExampleMediator2');
	}

	public function destroy():void
	{
		mediatorWatcher.notify('ExampleMediator2 destroy');
	}
}

class ExampleDisplayObjectMediator
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var mediatorWatcher:MediatorWatcher;

	[Inject]
	public var view:DisplayObject;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function initialize():void
	{
		mediatorWatcher.notify('ExampleDisplayObjectMediator');
	}
}

class RectangleMediator
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var rectangle:Rectangle;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function initialize():void
	{

	}
}

class OnlyIfViewHasChildrenGuard
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var view:Sprite;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function approve():Boolean
	{
		return (view.numChildren > 0);
	}
}

class HookWithMediatorAndViewInjectionDrawsRectangle
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var mediator:RectangleMediator;

	[Inject]
	public var view:Sprite;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function hook():void
	{
		const requiredWidth:Number = mediator.rectangle.width;
		const requiredHeight:Number = mediator.rectangle.height;

		view.graphics.drawRect(0, 0, requiredWidth, requiredHeight);
	}
}

class Alpha50PercentHook
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var view:Sprite;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function hook():void
	{
		view.alpha = 0.5;
	}
}

class HookA
{

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function hook():void
	{
	}
}

class NotAView
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	public var mediatorName:String;
}

class NotAViewMediator
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var notAView:NotAView;

	[Inject]
	public var mediatorWatcher:MediatorWatcher;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function initialize():void
	{
		notAView.mediatorName = 'NotAViewMediator';
		mediatorWatcher.notify('NotAViewMediator');
	}

	public function destroy():void
	{
		mediatorWatcher.notify('NotAViewMediator destroy');
	}
}
