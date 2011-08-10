package org.robotlegs.v2.viewmanager.listeningstrategies {

	import asunit.framework.TestCase;

	public class StageAndWindowsViewListeningStrategyTest extends TestCase {
		private var instance:StageAndWindowsViewListeningStrategy;

		public function StageAndWindowsViewListeningStrategyTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new StageAndWindowsViewListeningStrategy();
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is StageAndWindowsViewListeningStrategy", instance is StageAndWindowsViewListeningStrategy);
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
	}
}