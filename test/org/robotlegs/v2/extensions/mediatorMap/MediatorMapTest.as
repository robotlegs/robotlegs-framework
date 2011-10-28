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
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import org.robotlegs.v2.core.impl.TypeMatcher;
	import org.robotlegs.v2.core.impl.itemPassesFilter;
	import org.robotlegs.v2.core.api.ITypeFilter;
	import flash.display.MovieClip;
	import flash.geom.Rectangle;
	import org.robotlegs.v2.extensions.hooks.HooksProcessor;
	

	public class MediatorMapTest 
	{
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var instance:MediatorMap;
		
		private var injector:Injector;
		
		private var reflector:Reflector;
		
		private var mediatorWatcher:MediatorWatcher;
		
		private var hooksProcessor:HooksProcessor;
		
		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function setUp():void
		{
			instance = new MediatorMap();
			injector = new Injector();
			reflector = new DescribeTypeJSONReflector();
			mediatorWatcher = new MediatorWatcher();
			injector.map(MediatorWatcher).toValue(mediatorWatcher);
			hooksProcessor = new HooksProcessor();
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
		public function manually_instantiate_mediator():void
		{
			var mediator:ExampleMediator = injector.getInstance(ExampleMediator);
			
			var expectedNotifications:Vector.<String> = new <String>['ExampleMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}
		
		[Test]
		public function handler_instantiates_mediator_for_view_mapped_by_type():void
		{
			map(ExampleMediator).toView(Sprite);
			
			handleViewAdded(new Sprite());
			
			var expectedNotifications:Vector.<String> = new <String>['ExampleMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}
		
		[Test]
		public function handler_creates_mediator_for_view_mapped_by_matcher():void
		{
			map(ExampleMediator).toMatcher(new TypeMatcher().allOf(DisplayObject));
			
			handleViewAdded(new Sprite());

			var expectedNotifications:Vector.<String> = new <String>['ExampleMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}
		
		[Test]
		public function handler_doesnt_create_mediator_for_wrong_view_mapped_by_matcher():void
		{
			map(ExampleMediator).toMatcher(new TypeMatcher().allOf(MovieClip));
			
			handleViewAdded(new Sprite());

			var expectedNotifications:Vector.<String> = new <String>[];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}
		
		[Test]
		public function a_hook_runs_and_receives_injections_of_view_and_mediator():void
		{
			map(RectangleMediator).toView(Sprite).withHooks(HookWithMediatorAndViewInjectionDrawsRectangle);
			
			const view:Sprite = new Sprite();
			
			const expectedViewWidth:Number = 100;
			const expectedViewHeight:Number = 200;
			
			injector.map(Rectangle).toValue(new Rectangle(0,0,expectedViewWidth, expectedViewHeight));
			
			handleViewAdded(view);

			assertEquals(expectedViewWidth, view.width);
			assertEquals(expectedViewHeight, view.height);
		}
		
		// guards
		// hooks
		// view mapped as all types in the type filter all / any
		
		[Before]
		public function clearTDDAIYMI():void
		{
			_mappingsByMediatorClazz = new Dictionary();
			_mappingsByViewFCQN = new Dictionary();
			_mappingsByTypeFilter = new Dictionary();
		}
		
		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/
		
		protected var _mappingsByMediatorClazz:Dictionary;
		
		protected var _mappingsByViewFCQN:Dictionary;
		
		protected var _mappingsByTypeFilter:Dictionary;
		
		protected function map(mediatorClazz:Class):MediatorMappingBinding
		{			
			// TODO = fix the fatal flaw with this plan - we can only have one mapping per mediator...
			
			_mappingsByMediatorClazz[mediatorClazz] = new MediatorMappingBinding(_mappingsByViewFCQN, _mappingsByTypeFilter, mediatorClazz, reflector);
			
			return _mappingsByMediatorClazz[mediatorClazz];
		}
		
		protected function handleViewAdded(view:DisplayObject):void
		{
			const fqcn:String = getQualifiedClassName(view);
			
			if(_mappingsByViewFCQN[fqcn])
			{
				createMediatorForBinding(_mappingsByViewFCQN[fqcn], view);
				hooksProcessor.runHooks(injector, _mappingsByViewFCQN[fqcn].hooks);
			}	
			
			for (var filter:* in _mappingsByTypeFilter)
			{
				if(itemPassesFilter(view, filter as ITypeFilter))
				{
					createMediatorForBinding(_mappingsByTypeFilter[filter], view);
					hooksProcessor.runHooks(injector, _mappingsByTypeFilter[filter].hooks);
				}
			}
		}
		
		protected function createMediatorForBinding(binding:MediatorMappingBinding, view:DisplayObject):void
		{
			injector.map(binding.viewClass).toValue(view);
			const mediator:* = injector.getInstance(binding.mediatorClass);
			injector.map(binding.mediatorClass).toValue(mediator);
		}
	}
}

import flash.geom.Rectangle;
import flash.display.Sprite;

class ExampleMediator
{
	[Inject]
	public var mediatorWatcher:MediatorWatcher;
	
	[PostConstruct]
	public function notifyWatcher():void
	{
		mediatorWatcher.notify('ExampleMediator');
	}
}

class RectangleMediator
{
	[Inject]
	public var rectangle:Rectangle;
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
		trace("MediatorMapTest::hook()");
		const requiredWidth:Number = mediator.rectangle.width;
		const requiredHeight:Number = mediator.rectangle.height;
		
		view.graphics.drawRect(0,0, requiredWidth, requiredHeight);
	}
}