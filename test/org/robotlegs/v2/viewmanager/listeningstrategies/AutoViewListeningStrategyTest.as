package org.robotlegs.v2.viewmanager.listeningstrategies {

	import asunit.framework.TestCase;

	public class AutoViewListeningStrategyTest extends TestCase {
		private var instance:AutoViewListeningStrategy;

		public function AutoViewListeningStrategyTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new AutoViewListeningStrategy();
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is AutoViewListeningStrategy", instance is AutoViewListeningStrategy);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}