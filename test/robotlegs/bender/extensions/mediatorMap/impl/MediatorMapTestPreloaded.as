//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
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
	import org.flexunit.asserts.*;
	import org.flexunit.asserts.assertEqualsVectorsIgnoringOrder;
	import robotlegs.bender.extensions.matching.TypeMatcher;
	import robotlegs.bender.extensions.mediatorMap.impl.support.MediatorWatcher;
	import robotlegs.bender.extensions.viewManager.api.IViewHandler;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
	import org.flexunit.assertThat;
	import org.hamcrest.object.isTrue;
	import org.hamcrest.object.equalTo;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorViewHandler;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMappingConfig;
	import robotlegs.bender.framework.impl.guardSupport.HappyGuard;

	public class MediatorMapTestPreloaded
	{
		private var injector:Injector;

		private var instance:MediatorMap;
		
		private var handler:IMediatorViewHandler;
		
		private var factory:IMediatorFactory;
		
		private var mediatorWatcher:MediatorWatcher;
		
		private var mediatorManager:DefaultMediatorManager;

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

			assertFalse(injector.satisfiesDirectly(MovieClip));
			assertFalse(injector.satisfiesDirectly(Sprite));
			assertFalse(injector.satisfiesDirectly(ExampleMediator));
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
			assertTrue("instance is IViewHandler", instance is IViewHandler);
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
			assertEquals('NotAViewMediator', notAView.mediatorName);
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
		
		[Test(expects="robotlegs.bender.extensions.mediatorMap.api.MediatorMappingError")]
		public function error_thrown_if_2_mappings_made_with_same_matcher_and_mediator_but_different_guards():void
		{
			instance.map(Sprite).toMediator(ExampleMediator).withGuards(HappyGuard).withHooks(Alpha50PercentHook);
			instance.map(Sprite).toMediator(ExampleMediator).withGuards(OnlyIfViewHasChildrenGuard).withHooks(Alpha50PercentHook);			
		}
		
		[Test(expects="robotlegs.bender.extensions.mediatorMap.api.MediatorMappingError")]
		public function error_thrown_if_2_mappings_made_with_same_matcher_and_mediator_but_different_hooks():void
		{
			instance.map(Sprite).toMediator(ExampleMediator).withGuards(HappyGuard).withHooks(Alpha50PercentHook);
			instance.map(Sprite).toMediator(ExampleMediator).withGuards(HappyGuard).withHooks(HookWithMediatorAndViewInjectionDrawsRectangle);
		}
		
		[Test(expects="robotlegs.bender.extensions.mediatorMap.api.MediatorMappingError")]
		public function error_thrown_if_2_mappings_made_with_same_matcher_and_mediator_one_with_one_without_guards():void
		{
			instance.map(Sprite).toMediator(ExampleMediator).withGuards(HappyGuard);
			const mapping:IMediatorMapping = instance.map(Sprite).toMediator(ExampleMediator) as IMediatorMapping;
			// error only thrown when used sadly			
			mapping.matcher;			
		}
		
		[Test(expects="robotlegs.bender.extensions.mediatorMap.api.MediatorMappingError")]
		public function error_thrown_if_2_mappings_made_with_same_matcher_and_mediator_one_with_one_without_hooks():void
		{
			instance.map(Sprite).toMediator(ExampleMediator).withHooks(Alpha50PercentHook);
			const mapping:IMediatorMapping = instance.map(Sprite).toMediator(ExampleMediator) as IMediatorMapping;
			// error only thrown when used sadly			
			mapping.matcher;			
		}

		[Test]
		public function no_error_thrown_when_guards_and_hooks_are_chained():void
		{
			const mappingConfig:IMediatorMappingConfig = instance.map(Sprite).toMediator(ExampleMediator);
			mappingConfig.withGuards(HappyGuard);
			mappingConfig.withGuards(OnlyIfViewHasChildrenGuard);
			mappingConfig.withHooks(Alpha50PercentHook);
			mappingConfig.withHooks(HookWithMediatorAndViewInjectionDrawsRectangle);
		}
		
		[Test(expects="robotlegs.bender.extensions.mediatorMap.api.MediatorMappingError")]
		public function error_thrown_if_2_mappings_made_with_same_matcher_and_mediator_one_with_fewer_guards():void
		{
			instance.map(Sprite).toMediator(ExampleMediator).withGuards(HappyGuard, OnlyIfViewHasChildrenGuard);
			const mapping:MediatorMapping = instance.map(Sprite).toMediator(ExampleMediator) as MediatorMapping;
			mapping.withGuards(HappyGuard);
			// error only thrown when used sadly			
			mapping.matcher;			
		}
		
		[Test(expects="robotlegs.bender.extensions.mediatorMap.api.MediatorMappingError")]
		public function error_thrown_if_2_mappings_made_with_same_matcher_and_mediator_one_with_fewer_hooks():void
		{
			instance.map(Sprite).toMediator(ExampleMediator).withHooks(Alpha50PercentHook).withHooks(HookA);
			const mapping:MediatorMapping = instance.map(Sprite).toMediator(ExampleMediator) as MediatorMapping;
			mapping.withHooks(HookA);
			// error only thrown when used sadly			
			mapping.matcher;			
		}
		
		[Test]
		public function no_error_thrown_when_2_mappings_with_identical_guards_and_hooks_are_chained():void
		{
			const mapping1:MediatorMapping = instance.map(Sprite).toMediator(ExampleMediator) as MediatorMapping;
			mapping1.withGuards(HappyGuard);
			mapping1.withGuards(OnlyIfViewHasChildrenGuard);
			mapping1.withHooks(Alpha50PercentHook);
			mapping1.withHooks(HookWithMediatorAndViewInjectionDrawsRectangle);
			
			const mapping2:MediatorMapping = instance.map(Sprite).toMediator(ExampleMediator) as MediatorMapping;
			mapping2.withGuards(HappyGuard);
			mapping2.withGuards(OnlyIfViewHasChildrenGuard);
			mapping2.withHooks(HookWithMediatorAndViewInjectionDrawsRectangle);
			mapping2.withHooks(Alpha50PercentHook);

			mapping2.matcher;
		}
		
		[Test]
		public function mapping_guards_and_hooks_as_array_is_same_as_mapping_as_list():void
		{
			const mapping1:MediatorMapping = instance.map(Sprite).toMediator(ExampleMediator) as MediatorMapping;
			mapping1.withGuards(HappyGuard, OnlyIfViewHasChildrenGuard);
			mapping1.withHooks(Alpha50PercentHook, HookA);
			
			const mapping2:MediatorMapping = instance.map(Sprite).toMediator(ExampleMediator) as MediatorMapping;
			mapping2.withGuards([HappyGuard, OnlyIfViewHasChildrenGuard]);
			mapping2.withHooks([Alpha50PercentHook, HookA]);
			
			mapping2.matcher;
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


class ExampleMediator2
{
	[Inject]
	public var mediatorWatcher:MediatorWatcher;

	[Inject]
	public var view:Sprite;

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

class Alpha50PercentHook
{
	[Inject]
	public var view:Sprite;
	
	public function hook():void
	{
		view.alpha = 0.5;
	}
}

class HookA
{
	public function hook():void
	{
	}
}

class NotAView
{
	public var mediatorName:String;
}

class NotAViewMediator
{
	[Inject]
	public var notAView:NotAView

	[Inject]
	public var mediatorWatcher:MediatorWatcher;
	
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