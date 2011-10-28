//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap 
{
	import org.flexunit.asserts.*;
	import org.robotlegs.v2.view.api.IViewHandler;
	import org.swiftsuspenders.Injector;
	import org.swiftsuspenders.Reflector;
	import org.swiftsuspenders.DescribeTypeJSONReflector;
	import org.flexunit.asserts.assertEqualsVectorsIgnoringOrder;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import org.robotlegs.v2.core.impl.TypeMatcher;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import org.robotlegs.v2.extensions.hooks.HooksProcessor;
	import org.robotlegs.v2.extensions.guards.GuardsProcessor;
	

	public class MediatorMapTest 
	{
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var instance:MediatorMap;
		
		private var injector:Injector;
		
		private var reflector:Reflector;
		
		private var mediatorWatcher:MediatorWatcher;
		
		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function setUp():void
		{
			injector = new Injector();
			reflector = new DescribeTypeJSONReflector();

			instance = new MediatorMap();
			instance.hooksProcessor = new HooksProcessor();
			instance.guardsProcessor = new GuardsProcessor();
			instance.injector = injector;
			instance.reflector = reflector;
			instance.hooksProcessor = new HooksProcessor();
			instance.guardsProcessor = new GuardsProcessor();
			
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
		public function can_be_instantiated():void
		{
			assertTrue("instance is MediatorMap", instance is MediatorMap);
		}
		
		[Test]
		public function test_failure_seen():void
		{
			assertTrue("Failing test", true);
		}
		
		[Test]
		public function implements_IViewHandler():void
		{
			assertTrue("instance is IViewHandler", instance is IViewHandler);
		}
		
		[Test]
		public function handler_instantiates_mediator_for_view_mapped_by_type():void
		{
			instance.map(ExampleMediator).toView(Sprite);
			
			instance.handleViewAdded(new Sprite(), null);
			
			var expectedNotifications:Vector.<String> = new <String>['ExampleMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}
		
		[Test]
		public function handler_creates_mediator_for_view_mapped_by_matcher():void
		{
			instance.map(ExampleDisplayObjectMediator).toMatcher(new TypeMatcher().allOf(DisplayObject));
			
			instance.handleViewAdded(new Sprite(), null);

			var expectedNotifications:Vector.<String> = new <String>['ExampleDisplayObjectMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}
		
		[Test]
		public function handler_doesnt_create_mediator_for_wrong_view_mapped_by_matcher():void
		{
			instance.map(ExampleDisplayObjectMediator).toMatcher(new TypeMatcher().allOf(MovieClip));
			
			instance.handleViewAdded(new Sprite(), null);

			var expectedNotifications:Vector.<String> = new <String>[];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}
		
		[Test]
		public function a_hook_runs_and_receives_injections_of_view_and_mediator():void
		{
			instance.map(RectangleMediator).toView(Sprite).withHooks(HookWithMediatorAndViewInjectionDrawsRectangle);
			
			const view:Sprite = new Sprite();
			
			const expectedViewWidth:Number = 100;
			const expectedViewHeight:Number = 200;
			
			injector.map(Rectangle).toValue(new Rectangle(0,0,expectedViewWidth, expectedViewHeight));
			
			instance.handleViewAdded(view, null);

			assertEquals(expectedViewWidth, view.width);
			assertEquals(expectedViewHeight, view.height);
		}
		
		[Test]
		public function no_mediator_is_created_if_guard_prevents_it():void
		{
			instance.map(ExampleMediator).toView(Sprite).withGuards(OnlyIfViewHasChildrenGuard);
			const view:Sprite = new Sprite();
			instance.handleViewAdded(view, null);
			
			var expectedNotifications:Vector.<String> = new <String>[];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}
		
		[Test]
		public function mediator_is_created_if_guard_allows_it():void
		{
			instance.map(ExampleMediator).toView(Sprite).withGuards(OnlyIfViewHasChildrenGuard);
			const view:Sprite = new Sprite();
			view.addChild(new Sprite());
			instance.handleViewAdded(view, null);
			
			var expectedNotifications:Vector.<String> = new <String>['ExampleMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function returns_zero_if_handler_not_interested():void
		{
			instance.map(ExampleMediator).toView(MovieClip).withGuards(OnlyIfViewHasChildrenGuard);
			
			var interest:uint = instance.handleViewAdded(new Sprite(), null);
			
			assertEquals(0, interest);
		}

		[Test]
		public function returns_one_if_handler_interested():void
		{
			instance.map(ExampleMediator).toView(Sprite).withGuards(OnlyIfViewHasChildrenGuard);
			
			var interest:uint = instance.handleViewAdded(new Sprite(), null);
			
			assertEquals(1, interest);
		}
		
		// unmapping
		
		[Test]
		public function is_not_interested_if_mapping_is_unmapped_for_view():void
		{
			instance.map(ExampleMediator).toView(Sprite);
			instance.getMapping(ExampleMediator).unmap(new TypeMatcher().allOf(Sprite));
						
			var interest:uint = instance.handleViewAdded(new Sprite(), null);
			assertEquals(0, interest);
		}		
		
		[Test]
		public function is_not_interested_if_mapping_is_unmapped_for_matcher():void
		{
			instance.map(ExampleDisplayObjectMediator).toMatcher(new TypeMatcher().allOf(DisplayObject));
			instance.getMapping(ExampleDisplayObjectMediator).unmap(new TypeMatcher().allOf(DisplayObject));
			
			var interest:uint = instance.handleViewAdded(new Sprite(), null);
			assertEquals(0, interest);
		}
	}
}

import flash.geom.Rectangle;
import flash.display.Sprite;
import flash.display.DisplayObject;

class ExampleMediator
{
	[Inject]
	public var mediatorWatcher:MediatorWatcher;
	
	[Inject]
	public var view:Sprite;
	
	[PostConstruct]
	public function notifyWatcher():void
	{
		mediatorWatcher.notify('ExampleMediator');
	}
}

class ExampleDisplayObjectMediator
{
	[Inject]
	public var mediatorWatcher:MediatorWatcher;
	
	[Inject]
	public var view:DisplayObject;
	
	[PostConstruct]
	public function notifyWatcher():void
	{
		mediatorWatcher.notify('ExampleDisplayObjectMediator');
	}
}

class RectangleMediator
{
	[Inject]
	public var rectangle:Rectangle;
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

class MediatorWatcher
{
	protected const _notifications:Vector.<String> = new Vector.<String>();
	
	public function notify(message:String):void
	{
		_notifications.push(message);
	}
	
	public function get notifications():Vector.<String>
	{
		return _notifications;
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
		
		view.graphics.drawRect(0,0, requiredWidth, requiredHeight);
	}
}