//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import flash.display.Sprite;
	import flash.system.System;
	import flash.utils.Dictionary;
	import org.flexunit.asserts.assertEquals;
	import org.flexunit.async.Async;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorViewHandler;
	import robotlegs.bender.extensions.mediatorMap.impl.support.MediatorWeakMapTracker;

	public class MediatorMapMemoryLeakTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var mediatorMap:MediatorMap;

		private var mediatorTracker:MediatorWeakMapTracker;

		private var mediatorManager:MediatorManager;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function setUp():void
		{
			const injector:Injector = new Injector();
			const factory:IMediatorFactory = new MediatorFactory(injector);
			const handler:IMediatorViewHandler = new MediatorViewHandler(factory);
			mediatorMap = new MediatorMap(factory, handler);
			mediatorManager = new MediatorManager(factory);

			mediatorTracker = new MediatorWeakMapTracker();
			injector.map(MediatorWeakMapTracker).toValue(mediatorTracker);
		}

		[After]
		public function tearDown():void
		{
			mediatorMap = null;
			mediatorManager = null;
			mediatorTracker = null;
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test(async)]
		public function mediators_are_released_and_not_held_in_memory():void
		{
			mediatorMap.map(Sprite).toMediator(ExampleMediator);
			mediatorMap.map(Sprite).toMediator(ExampleMediator2);

			const view:Sprite = new Sprite();

			mediatorMap.mediate(view);

			const trackedMediators:Dictionary = mediatorTracker.trackedMediators;

			var expectedNumberOfKeys:uint = 2;
			assertEquals(expectedNumberOfKeys, dictionaryLength(trackedMediators));

			mediatorMap.unmediate(view);
			System.gc();

			expectedNumberOfKeys = 0;

			assertAfterDelay(function():void {
				assertEquals(expectedNumberOfKeys, dictionaryLength(trackedMediators));
			}, 50);
		}

		[Test(async)]
		public function mediated_view_is_released_and_not_held_in_memory():void
		{
			mediatorMap.map(Sprite).toMediator(ExampleMediator);
			mediatorMap.map(Sprite).toMediator(ExampleMediator2);

			var views:Array = [];
			views[0] = new Sprite();

			const trackedViews:Dictionary = new Dictionary(true);
			trackedViews[views[0]] = true;

			mediatorMap.mediate(views[0]);

			var expectedNumberOfKeys:uint = 1;
			assertEquals(expectedNumberOfKeys, dictionaryLength(trackedViews));

			mediatorMap.unmediate(views[0]);
			views[0] = new Sprite();
			System.gc();

			expectedNumberOfKeys = 0;

			assertAfterDelay(function():void {
				assertEquals(expectedNumberOfKeys, dictionaryLength(trackedViews));
			}, 50);
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		protected function dictionaryLength(dict:Dictionary):uint
		{
			var itemsFound:uint = 0;
			for each (var item:Object in dict)
			{
				itemsFound++;
			}
			return itemsFound;
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function assertAfterDelay(assertion:Function, delay:Number = 50):void
		{
			Async.delayCall(this, assertion, delay);
		}
	}
}

import flash.display.Sprite;
import robotlegs.bender.extensions.mediatorMap.impl.support.MediatorWeakMapTracker;

class ExampleMediator
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var mediatorTracker:MediatorWeakMapTracker;

	[Inject]
	public var view:Sprite;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

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

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var mediatorTracker:MediatorWeakMapTracker;

	[Inject]
	public var view:Sprite;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function initialize():void
	{
		mediatorTracker.trackMediator(this);
	}

	public function destroy():void
	{
	}
}
