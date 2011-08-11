package org.robotlegs.v2.viewmanager.tasks {

	import asunit.framework.TestCase;

	public class TaskTypeTest extends TestCase {
		private var instance:TaskType;
		protected const SOME_TYPE:String = "Some type";

		public function TaskTypeTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new TaskType(SOME_TYPE);
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is TaskType", instance is TaskType);
		}

		public function testFailure():void {
			assertTrue("Failing test", true);
		}
		
		public function test_get_type():void {
			assertEquals("Get type", SOME_TYPE, instance.type);
		}
	}
}