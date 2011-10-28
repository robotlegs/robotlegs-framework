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
	import org.robotlegs.v2.extensions.mediatorMap.MediatorMappingBinding;
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
		
		private var hooksProcessor:HooksProcessor;
		
		private var guardsProcessor:GuardsProcessor;
		
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
			guardsProcessor = new GuardsProcessor();
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
			map(ExampleMediator).toView(Sprite);
			
			handleViewAdded(new Sprite());
			
			var expectedNotifications:Vector.<String> = new <String>['ExampleMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}
		
		[Test]
		public function handler_creates_mediator_for_view_mapped_by_matcher():void
		{
			map(ExampleDisplayObjectMediator).toMatcher(new TypeMatcher().allOf(DisplayObject));
			
			handleViewAdded(new Sprite());

			var expectedNotifications:Vector.<String> = new <String>['ExampleDisplayObjectMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}
		
		[Test]
		public function handler_doesnt_create_mediator_for_wrong_view_mapped_by_matcher():void
		{
			map(ExampleDisplayObjectMediator).toMatcher(new TypeMatcher().allOf(MovieClip));
			
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
		
		[Test]
		public function no_mediator_is_created_if_guard_prevents_it():void
		{
			map(ExampleMediator).toView(Sprite).withGuards(OnlyIfViewHasChildrenGuard);
			const view:Sprite = new Sprite();
			handleViewAdded(view);
			
			var expectedNotifications:Vector.<String> = new <String>[];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}
		
		[Test]
		public function mediator_is_created_if_guard_allows_it():void
		{
			map(ExampleMediator).toView(Sprite).withGuards(OnlyIfViewHasChildrenGuard);
			const view:Sprite = new Sprite();
			view.addChild(new Sprite());
			handleViewAdded(view);
			
			var expectedNotifications:Vector.<String> = new <String>['ExampleMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function returns_zero_if_handler_not_interested():void
		{
			map(ExampleMediator).toView(Sprite).withGuards(OnlyIfViewHasChildrenGuard);
			
			var interest:uint = handleViewAdded(new MovieClip());
			
			assertEquals(0, interest);
		}

		[Test]
		public function returns_one_if_handler_interested():void
		{
			map(ExampleMediator).toView(Sprite).withGuards(OnlyIfViewHasChildrenGuard);
			
			var interest:uint = handleViewAdded(new Sprite());
			
			assertEquals(1, interest);
		}
		
		
		
		// view mapped as all types in the type filter all / any
		// unmapping
		
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
		
		protected function handleViewAdded(view:DisplayObject):uint
		{
			const fqcn:String = getQualifiedClassName(view);
			var interest:uint = 0;
			
			if(_mappingsByViewFCQN[fqcn])
			{
				interest = 1;
				mapViewForTypeBinding(_mappingsByViewFCQN[fqcn], view);
				processMapping( _mappingsByViewFCQN[fqcn]);
			}	
			
			for (var filter:* in _mappingsByTypeFilter)
			{
				if(itemPassesFilter(view, filter as ITypeFilter))
				{
					interest = 1;
					mapViewForFilterBinding(filter, view);
					processMapping (_mappingsByTypeFilter[filter]);
				}
			}
			
			return interest;
		}
		
		protected function processMapping(binding:MediatorMappingBinding):void
		{
			if(!blockedByGuards(binding.guards))
			{
				createMediatorForBinding(binding);
				hooksProcessor.runHooks(injector, binding.hooks);
			}
		}

		protected function mapViewForTypeBinding(binding:MediatorMappingBinding, view:DisplayObject):void
		{
			injector.map(binding.viewClass).toValue(view);
		}

		protected function mapViewForFilterBinding(filter:ITypeFilter, view:DisplayObject):void
		{
			var requiredClazz:Class;
			
			for each (requiredClazz in filter.allOfTypes)
			{
				injector.map(requiredClazz).toValue(view);
			}
			
			for each (requiredClazz in filter.anyOfTypes)
			{
				injector.map(requiredClazz).toValue(view);
			}
		}
		
		protected function createMediatorForBinding(binding:MediatorMappingBinding):void
		{
			const mediator:* = injector.getInstance(binding.mediatorClass);
			injector.map(binding.mediatorClass).toValue(mediator);
		}
		
		protected function blockedByGuards(guards:Vector.<Class>):Boolean
		{
			return ((guards.length > 0) 
					&& !( guardsProcessor.processGuards(injector , guards) ) )
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