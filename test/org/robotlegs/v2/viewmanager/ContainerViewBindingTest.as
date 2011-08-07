package org.robotlegs.v2.viewmanager {

	import asunit.framework.TestCase;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import org.robotlegs.v2.viewmanager.IContainerViewBinding;

	public class ContainerViewBindingTest extends TestCase {
		private var instance:ContainerViewBinding;
		protected const CONTAINER_VIEW:DisplayObjectContainer = new Sprite(); 
		protected const PARENT:ContainerViewBinding = new ContainerViewBinding(new Sprite(), removeHandler);
		protected var _removedBinding:IContainerViewBinding;

		public function ContainerViewBindingTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new ContainerViewBinding(CONTAINER_VIEW, removeHandler);
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is ContainerViewBinding", instance is ContainerViewBinding);
		}

		public function testFailure():void {
			assertTrue("Failing test", true);
		}
		
		public function test_get_containerView():void {
			assertEquals("Get containerView", CONTAINER_VIEW, instance.containerView);
		}  
		
		public function test_set_parent():void {
			instance.parent =  PARENT;
			assertEquals("Set parent", PARENT, instance.parent);
		} 
		
		public function test_remove_runs_removeHandler_passing_self():void { 
			instance.remove();
			assertEquals("Remove runs removeHandler passing self ", instance, _removedBinding);
		}
		
		protected function removeHandler(binding:IContainerViewBinding):void
		{
			_removedBinding = binding;
		}
	}
}