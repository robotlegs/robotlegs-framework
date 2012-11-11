//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import org.flexunit.Assert;
	import org.flexunit.asserts.assertEqualsVectorsIgnoringOrder;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.matching.TypeMatcher;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorViewHandler;
	import robotlegs.bender.extensions.mediatorMap.impl.support.MediatorWatcher;
	import robotlegs.bender.extensions.viewManager.api.IViewHandler;
	import robotlegs.bender.framework.impl.guardSupport.HappyGuard;

	public class MediatorMapTestPreloaded
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		// TODO: refactor tests so that we're testing at the right levels of abstraction
		// and testing actual implementations

		private var injector:Injector;

		private var instance:MediatorMap;

		private var handler:IMediatorViewHandler;

		private var factory:IMediatorFactory;

		private var mediatorWatcher:MediatorWatcher;

		private var mediatorManager:DefaultMediatorManager;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function setUp():void
		{
			injector = new Injector();
			factory = new MediatorFactory(injector);
			handler = new MediatorViewHandler(factory);
			instance = new MediatorMap(factory, handler);
			mediatorManager = new DefaultMediatorManager(factory);

			mediatorWatcher = new MediatorWatcher();
			injector.map(MediatorWatcher).toValue(mediatorWatcher);
		}

		[After]
		public function tearDown():void
		{
			instance = null;
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function a_hook_runs_and_receives_injections_of_view_and_mediator():void
		{
			instance.map(Sprite).toMediator(RectangleMediator).withHooks(HookWithMediatorAndViewInjectionDrawsRectangle);

			const view:Sprite = new Sprite();

			const expectedViewWidth:Number = 100;
			const expectedViewHeight:Number = 200;

			injector.map(Rectangle).toValue(new Rectangle(0, 0, expectedViewWidth, expectedViewHeight));

			instance.handleView(view, null);

			assertThat(expectedViewWidth, equalTo(view.width));
			assertThat(expectedViewHeight, equalTo(view.height));
		}

		[Test]
		public function can_be_instantiated():void
		{
			assertThat(instance is MediatorMap, isTrue());
		}

		[Test]
		public function create_mediator_instantiates_mediator_for_view_when_mapped():void
		{
			instance.map(Sprite).toMediator(ExampleMediator);

			instance.handleView(new Sprite(), null);

			const expectedNotifications:Vector.<String> = new <String>['ExampleMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function doesnt_leave_view_and_mediator_mappings_lying_around():void
		{
			instance.mapMatcher(new TypeMatcher().anyOf(MovieClip, Sprite)).toMediator(ExampleMediator);
			instance.handleView(new Sprite(), null);

			assertThat(injector.satisfiesDirectly(MovieClip), isFalse());
			assertThat(injector.satisfiesDirectly(Sprite), isFalse());
			assertThat(injector.satisfiesDirectly(ExampleMediator), isFalse());
		}

		[Test]
		public function handler_creates_mediator_for_view_mapped_by_matcher():void
		{
			instance.mapMatcher(new TypeMatcher().allOf(DisplayObject)).toMediator(ExampleDisplayObjectMediator);

			instance.handleView(new Sprite(), null);

			const expectedNotifications:Vector.<String> = new <String>['ExampleDisplayObjectMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function handler_doesnt_create_mediator_for_wrong_view_mapped_by_matcher():void
		{
			instance.mapMatcher(new TypeMatcher().allOf(MovieClip)).toMediator(ExampleDisplayObjectMediator);

			instance.handleView(new Sprite(), null);

			const expectedNotifications:Vector.<String> = new <String>[];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function handler_instantiates_mediator_for_view_mapped_by_type():void
		{
			instance.map(Sprite).toMediator(ExampleMediator);

			instance.handleView(new Sprite(), null);

			const expectedNotifications:Vector.<String> = new <String>['ExampleMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function implements_IViewHandler():void
		{
			assertThat(instance, instanceOf(IViewHandler));
		}

		[Test]
		public function mediate_instantiates_mediator_for_view_when_matched_to_mapping():void
		{
			instance.map(Sprite).toMediator(ExampleMediator);

			instance.mediate(new Sprite());

			const expectedNotifications:Vector.<String> = new <String>['ExampleMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function mediator_is_created_if_guard_allows_it():void
		{
			instance.map(Sprite).toMediator(ExampleMediator).withGuards(OnlyIfViewHasChildrenGuard);
			const view:Sprite = new Sprite();
			view.addChild(new Sprite());
			instance.mediate(view);

			const expectedNotifications:Vector.<String> = new <String>['ExampleMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function no_mediator_is_created_if_guard_prevents_it():void
		{
			instance.map(Sprite).toMediator(ExampleMediator).withGuards(OnlyIfViewHasChildrenGuard);
			const view:Sprite = new Sprite();
			instance.mediate(view);

			const expectedNotifications:Vector.<String> = new <String>[];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function runs_destroy_on_created_mediator_when_unmediate_runs():void
		{
			instance.map(Sprite).toMediator(ExampleMediator);

			const view:Sprite = new Sprite();
			instance.mediate(view);
			instance.unmediate(view);

			const expectedNotifications:Vector.<String> = new <String>['ExampleMediator', 'ExampleMediator destroy'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function mediator_is_created_for_non_view_object():void
		{
			instance.map(NotAView).toMediator(NotAViewMediator);
			const notAView:NotAView = new NotAView();
			instance.mediate(notAView);

			const expectedNotifications:Vector.<String> = new <String>['NotAViewMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function non_view_object_injected_into_mediator_correctly():void
		{
			instance.map(NotAView).toMediator(NotAViewMediator);
			const notAView:NotAView = new NotAView();
			instance.mediate(notAView);
			assertThat(notAView.mediatorName, equalTo('NotAViewMediator'));
		}

		[Test]
		public function mediator_is_destroyed_for_non_view_object():void
		{
			instance.map(NotAView).toMediator(NotAViewMediator);
			const notAView:NotAView = new NotAView();
			instance.mediate(notAView);
			instance.unmediate(notAView);

			const expectedNotifications:Vector.<String> = new <String>['NotAViewMediator', 'NotAViewMediator destroy'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function unmediate_cleans_up_mediators():void
		{
			instance.map(Sprite).toMediator(ExampleMediator);

			const view:Sprite = new Sprite();

			instance.mediate(view);
			instance.unmediate(view);

			const expectedNotifications:Vector.<String> = new <String>['ExampleMediator', 'ExampleMediator destroy'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function multiple_mappings_per_matcher_create_mediators():void
		{
			instance.map(Sprite).toMediator(ExampleMediator);
			instance.map(Sprite).toMediator(ExampleMediator2);

			instance.mediate(new Sprite());
			const expectedNotifications:Vector.<String> = new <String>['ExampleMediator', 'ExampleMediator2'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function multiple_mappings_per_matcher_destroy_mediators():void
		{
			instance.map(Sprite).toMediator(ExampleMediator);
			instance.map(Sprite).toMediator(ExampleMediator2);

			const view:Sprite = new Sprite();

			instance.mediate(view);
			instance.unmediate(view);

			const expectedNotifications:Vector.<String> = new <String>['ExampleMediator', 'ExampleMediator2', 'ExampleMediator destroy', 'ExampleMediator2 destroy'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function only_one_mediator_created_if_identical_mapping_duplicated():void
		{
			instance.map(Sprite).toMediator(ExampleMediator).withGuards(HappyGuard).withHooks(Alpha50PercentHook);
			instance.map(Sprite).toMediator(ExampleMediator).withGuards(HappyGuard).withHooks(Alpha50PercentHook);

			instance.mediate(new Sprite());
			const expectedNotifications:Vector.<String> = new <String>['ExampleMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function removing_a_mapping_that_doesnt_exist_doesnt_throw_an_error():void
		{
			instance.unmap(Sprite).fromMediator(ExampleMediator);
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

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
