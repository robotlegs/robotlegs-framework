//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.viewmanager
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import asunit.framework.TestCase;
	import org.robotlegs.v2.viewmanager.listeningstrategies.FewestListenersViewListeningStrategy;
	import org.robotlegs.v2.viewmanager.listeningstrategies.ManualViewListeningStrategy;

	public class ListeningStrategyFactoryTest extends TestCase
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var instance:ListeningStrategyFactory;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ListeningStrategyFactoryTest(methodName:String = null)
		{
			super(methodName)
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function testFailure():void
		{
			assertTrue("Failing test", true);
		}

		public function testInstantiated():void
		{
			assertTrue("instance is ListeningStrategyFactory", instance is ListeningStrategyFactory);
		}

		public function test_creates_matching_strategy_by_type():void
		{
			var originalStrategy:FewestListenersViewListeningStrategy = new FewestListenersViewListeningStrategy(null);
			var newStrategy:IListeningStrategy = instance.createStrategyLike(originalStrategy);
			assertTrue("Creates matching strategy by type", newStrategy is FewestListenersViewListeningStrategy);
		}

		public function test_creates_matching_strategy_with_matching_targets():void
		{
			var targets:Vector.<DisplayObjectContainer> = new <DisplayObjectContainer>[new Sprite(), new Sprite()];
			var originalStrategy:ManualViewListeningStrategy = new ManualViewListeningStrategy(targets);
			var newStrategy:IListeningStrategy = instance.createStrategyLike(originalStrategy);
			assertEqualsVectorsIgnoringOrder("Creates matching strategy with matching targets", targets, newStrategy.targets);
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		override protected function setUp():void
		{
			super.setUp();
			instance = new ListeningStrategyFactory();
		}

		override protected function tearDown():void
		{
			super.tearDown();
			instance = null;
		}
	}
}
