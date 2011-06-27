package <%= package_name %> {

	import asunit.framework.TestCase;
	
	import flash.events.Event;

	public class <%= test_case_name  %> extends TestCase {
		private var <%= instance_name %>:<%= class_name %>;

		public function <%= test_case_name %>(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			<%= instance_name %> = new <%= class_name %>('testEvent');
		}

		override protected function tearDown():void {
			super.tearDown();
			<%= instance_name %> = null;
		}

		public function testInstantiated():void {
			assertTrue("<%= instance_name %> is <%= class_name %>", <%= instance_name %> is <%= class_name %>);
		}
        
		public function testIsEvent():void{
			assertTrue("<%= instance_name %> is Event", <%= instance_name %> is Event);
		}
        
        public function testCloneReturnsSameEvent():void{
	    	var eventType:String = "testEvent";
			var clone:<%= class_name %> = <%= instance_name %>.clone() as <%= class_name %>;
			assertTrue("<%= class_name %> can be cloned to correct class", clone is <%= class_name %>);
			assertTrue("<%= class_name %> clone retains event type", clone.type == "testEvent");
		}
		
		public function testEventStrings():void{
		   	assertTrue("<%= class_name %>.EVENT_TYPE has correct string", <%= class_name %>.EVENT_TYPE == 'eventType');
		}

		public function testFailure():void {
			assertTrue("Failing test", false);
		}
		
	}
}