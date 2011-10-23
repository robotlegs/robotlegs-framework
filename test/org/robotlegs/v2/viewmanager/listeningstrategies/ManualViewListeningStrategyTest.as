//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.viewmanager.listeningstrategies
{
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import asunit.framework.TestCase;
	import org.robotlegs.v2.viewmanager.IListeningStrategy;

	public class ManualViewListeningStrategyTest extends TestCase
	{

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected var TARGETS:Vector.<DisplayObjectContainer> = new <DisplayObjectContainer>[new Sprite(), new Sprite()];

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var instance:ManualViewListeningStrategy;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ManualViewListeningStrategyTest(methodName:String = null)
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
			assertTrue("instance is ManualViewListeningStrategy", instance is ManualViewListeningStrategy);
		}

		public function test_implements_IListeningStrategy():void
		{
			assertTrue("Implements IListeningStrategy ", instance is IListeningStrategy);
		}

		public function test_targets_returns_value_given_in_constructor():void
		{
			assertEqualsVectorsIgnoringOrder("Targets returns value given in constructor", TARGETS, instance.targets);
		}

		public function test_targets_returns_value_given_in_constructor_after_change():void
		{
			instance.updateTargets(new <DisplayObjectContainer>[new Sprite()]);
			assertEqualsVectorsIgnoringOrder("Targets returns value given in constructor", TARGETS, instance.targets);
		}

		public function test_updating_returns_false():void
		{
			assertFalse("Updating returns false", instance.updateTargets(new <DisplayObjectContainer>[new Sprite()]));
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		override protected function setUp():void
		{
			super.setUp();
			instance = new ManualViewListeningStrategy(TARGETS);
		}

		override protected function tearDown():void
		{
			super.tearDown();
			instance = null;
		}
	}
}
