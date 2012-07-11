//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import flash.display.Sprite;
	import flash.events.Event;
	import org.flexunit.Assert;
	import org.flexunit.asserts.*;
	import org.flexunit.async.Async;
	import robotlegs.bender.extensions.mediatorMap.impl.support.MediatorWatcher;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorViewHandler;
	import robotlegs.bender.extensions.mediatorMap.impl.support.MediatorWeakMapTracker;
	import flash.utils.Dictionary;
	import flash.system.System;

	public class MediatorMapMemoryLeakTest
	{
		private var injector:Injector;

		private var instance:MediatorMap;
		
		private var handler:IMediatorViewHandler;
		
		private var factory:IMediatorFactory;
		
		private var mediatorTracker:MediatorWeakMapTracker;
		
		private var mediatorManager:DefaultMediatorManager;

		[Before]
		public function setUp():void
		{
			injector = new Injector();
			factory = new MediatorFactory(injector);
			handler = new MediatorViewHandler(factory);
			instance = new MediatorMap(factory, handler);
			mediatorManager = new DefaultMediatorManager(factory);

			mediatorTracker = new MediatorWeakMapTracker();
			injector.map(MediatorWeakMapTracker).toValue(mediatorTracker);
		}

		[After]
		public function tearDown():void
		{
			instance = null;
		}

		[Test(async)]
		public function mediators_are_released_and_not_held_in_memory():void
		{
			instance.map(Sprite).toMediator(ExampleMediator);
			instance.map(Sprite).toMediator(ExampleMediator2);
			
			const view:Sprite = new Sprite();
			
			instance.mediate(view);
			
			const trackedMediators:Dictionary = mediatorTracker.trackedMediators;
			
			var expectedNumberOfKeys:uint = 2;
			assertEquals(expectedNumberOfKeys, dictionaryLength(trackedMediators));
		
			instance.unmediate(view);
			System.gc();
			
			expectedNumberOfKeys = 0;
			
			assertAfterDelay( function():void 
								{
									assertEquals(expectedNumberOfKeys, dictionaryLength(trackedMediators));
								}, 
								50	);
		}
		
		[Test(async)]
		public function mediated_view_is_released_and_not_held_in_memory():void
		{
			instance.map(Sprite).toMediator(ExampleMediator);
			instance.map(Sprite).toMediator(ExampleMediator2);
			
			var views:Array = [];
			views[0] = new Sprite();
			
			const trackedViews:Dictionary = new Dictionary(true);
			trackedViews[views[0]] = true;
			
			instance.mediate(views[0]);
			
			var expectedNumberOfKeys:uint = 1;
			assertEquals(expectedNumberOfKeys, dictionaryLength(trackedViews));
		
			instance.unmediate(views[0]);
			views[0] = new Sprite();
			System.gc();
			
			expectedNumberOfKeys = 0;
			
			assertAfterDelay( function():void 
					{
						assertEquals(expectedNumberOfKeys, dictionaryLength(trackedViews));
					}, 
					50	);
		}	
		
		protected function handleEventTimeout(o:Object):void
		{
			Assert.fail("The event never fired");
		}

		protected function benignHandler(e:Event, o:Object):void
		{
			// do nothing
		}
		
		protected function dictionaryLength(dict:Dictionary):uint
		{
			var itemsFound:uint = 0;
			for each (var item:Object in dict)
			{
				itemsFound++;
			}
			return itemsFound;
		}
		
		private function assertAfterDelay(assertion:Function, delay:Number = 50):void
		{
			Async.delayCall(this, assertion, delay);
		}
	}
}

import robotlegs.bender.extensions.mediatorMap.impl.support.MediatorWatcher;
import flash.display.Sprite;
import robotlegs.bender.extensions.mediatorMap.impl.support.MediatorWeakMapTracker;

class ExampleMediator
{
	[Inject]
		public var mediatorTracker:MediatorWeakMapTracker;

	[Inject]
	public var view:Sprite;

	public function initialize():void
	{
		mediatorTracker.trackMediator(this);
	}

	public function destroy():void
	{
	}
}


class ExampleMediator2
{
	[Inject]
	public var mediatorTracker:MediatorWeakMapTracker;

	[Inject]
	public var view:Sprite;

	public function initialize():void
	{
		mediatorTracker.trackMediator(this);
	}

	public function destroy():void
	{
	}
}