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
			instance = new MediatorMap();
			injector = new Injector();
			reflector = new DescribeTypeJSONReflector();
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
		
		// handler_creates_mediator_for_view_mapped_by_matcher
		// guards
		// hooks
		

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/
		
		protected var _mappingsByMediatorClazz:Dictionary = new Dictionary();
		
		protected var _mappingsByViewFCQN:Dictionary = new Dictionary();
		
		protected function map(mediatorClazz:Class):MediatorMappingBinding
		{			
			_mappingsByMediatorClazz[mediatorClazz] = new MediatorMappingBinding(_mappingsByViewFCQN, mediatorClazz, reflector);
			
			
			return _mappingsByMediatorClazz[mediatorClazz];
		}
		
		protected function handleViewAdded(view:DisplayObject):void
		{
			const fqcn:String = getQualifiedClassName(view);
			
			if(_mappingsByViewFCQN[fqcn])
				createMediatorForBinding(_mappingsByViewFCQN[fqcn], view);
		}
		
		protected function createMediatorForBinding(binding:MediatorMappingBinding, view:DisplayObject):void
		{
			injector.map(binding.viewClass).toValue(view);
			injector.getInstance(binding.mediatorClass);
		}
	}
}

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