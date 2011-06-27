package org.roburntlegs.experiments {

	import asunit.framework.TestCase;

	public class ViewManagerTest extends TestCase {
		private var instance:ViewManager;  
		protected var _callbackCalled:Boolean;

		public function ViewManagerTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();                    
			_callbackCalled = false;
			instance = new ViewManager();
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is ViewManager", instance is ViewManager);
		}

		public function testFailure():void {
			assertTrue("Failing test", true);
		}                                  
		
		public function test_ADDED_TO_STAGE_triggers_callback():void {
			assertTrue("ADDED TO STAGE triggers callback ", _callbackCalled);
		}
		
	}
}