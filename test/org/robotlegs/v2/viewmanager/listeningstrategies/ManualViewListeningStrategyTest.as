package org.robotlegs.v2.viewmanager.listeningstrategies {

	import asunit.framework.TestCase;

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	import org.robotlegs.v2.viewmanager.IListeningStrategy;

	public class ManualViewListeningStrategyTest extends TestCase {
		private var instance:ManualViewListeningStrategy; 
		protected var TARGETS:Vector.<DisplayObjectContainer> = new <DisplayObjectContainer>[new Sprite(), new Sprite()];

		public function ManualViewListeningStrategyTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new ManualViewListeningStrategy(TARGETS);
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is ManualViewListeningStrategy", instance is ManualViewListeningStrategy);
		}

		public function testFailure():void {
			assertTrue("Failing test", true);
		}  
		
		public function test_implements_IListeningStrategy():void {
			assertTrue("Implements IListeningStrategy ", instance is IListeningStrategy);
		}
		
		public function test_targets_returns_value_given_in_constructor():void {
			assertEqualsVectorsIgnoringOrder("Targets returns value given in constructor", TARGETS, instance.targets);
		} 
		
		public function test_targets_returns_value_given_in_constructor_after_change():void { 
			instance.updateTargets(new <DisplayObjectContainer>[new Sprite()]);
			assertEqualsVectorsIgnoringOrder("Targets returns value given in constructor", TARGETS, instance.targets);
		}
		
		public function test_updating_returns_false():void {
			assertFalse("Updating returns false", instance.updateTargets(new <DisplayObjectContainer>[new Sprite()]));
		}
	}
}