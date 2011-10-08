package org.robotlegs.v2.viewmanager {

	import asunit.framework.TestCase;

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	public class ContainerBindingTest extends TestCase {
		private var instance:ContainerBinding;
		protected const CONTAINER_VIEW:DisplayObjectContainer = new Sprite(); 
		protected const PARENT:ContainerBinding = new ContainerBinding(new Sprite(), removeHandler);
		protected var _removedBinding:IContainerBinding;

		public function ContainerBindingTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new ContainerBinding(CONTAINER_VIEW, removeHandler);
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is ContainerBinding", instance is ContainerBinding);
		}

		public function testFailure():void {
			assertTrue("Failing test", true);
		}
		
		public function test_get_container():void {
			assertEquals("Get container", CONTAINER_VIEW, instance.container);
		}  
		
		public function test_set_parent():void {
			instance.parent =  PARENT;
			assertEquals("Set parent", PARENT, instance.parent);
		} 
		
		public function test_remove_runs_removeHandler_passing_self():void { 
			instance.remove();
			assertEquals("Remove runs removeHandler passing self ", instance, _removedBinding);
		}
		
		protected function removeHandler(binding:IContainerBinding):void
		{
			_removedBinding = binding;
		} 
	}
}