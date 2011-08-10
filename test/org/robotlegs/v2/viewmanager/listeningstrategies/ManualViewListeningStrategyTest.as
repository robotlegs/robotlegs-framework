package org.robotlegs.v2.viewmanager.listeningstrategies {

	import asunit.framework.TestCase;

	public class ManualViewListeningStrategyTest extends TestCase {
		private var instance:ManualViewListeningStrategy;

		public function ManualViewListeningStrategyTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new ManualViewListeningStrategy();
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is ManualViewListeningStrategy", instance is ManualViewListeningStrategy);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}