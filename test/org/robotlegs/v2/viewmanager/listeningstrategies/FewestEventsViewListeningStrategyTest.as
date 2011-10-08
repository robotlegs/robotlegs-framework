package org.robotlegs.v2.viewmanager.listeningstrategies {

	import asunit.framework.TestCase;

	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	import org.robotlegs.v2.viewmanager.IListeningStrategy;

	public class FewestEventsViewListeningStrategyTest extends TestCase {
		private var instance:FewestEventsViewListeningStrategy;

		public function FewestEventsViewListeningStrategyTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new FewestEventsViewListeningStrategy(null);
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is FewestEventsViewListeningStrategy", instance is FewestEventsViewListeningStrategy);
		}

		public function test_implements_IListeningStrategy():void {
			assertTrue("Implements IListeningStrategy", instance is IListeningStrategy);
		}
		
		public function testFailure():void {
			assertTrue("Failing test", true);
		}
		
		public function test_targets_initially_empty():void {
			assertEquals("Targets initially empty", 0, instance.targets.length);
		}
		 
		public function test_returns_list_as_given():void {
			var parentView:Sprite = new Sprite();
			var childView1:Sprite = new Sprite();
			var childView2:Sprite = new Sprite();
			
			parentView.addChild(childView1);
			parentView.addChild(childView2);
			                                
			var listGiven:Vector.<DisplayObjectContainer> = new <DisplayObjectContainer>[childView2, childView1];
			instance.updateTargets(listGiven);
			
			assertEqualsVectorsIgnoringOrder("Returns nearest parent for sibling views", listGiven, instance.targets);
		}
		
	    public function test_returns_false_if_no_change_in_targets():void {
			var parentView:Sprite = new Sprite();
			var childView1:Sprite = new Sprite();
			var childView2:Sprite = new Sprite();
			
			parentView.addChild(childView1);
			parentView.addChild(childView2);
			                                
			var listGiven:Vector.<DisplayObjectContainer> = new <DisplayObjectContainer>[childView2, childView1];
			instance.updateTargets(listGiven);

			var copyListGiven:Vector.<DisplayObjectContainer> = listGiven.slice();
			
			assertFalse("Returns false if no change in targets", instance.updateTargets(copyListGiven));
		}
		
		public function test_returns_false_if_no_change_in_targets_except_order():void {
			var parentView:Sprite = new Sprite();
			var childView1:Sprite = new Sprite();
			var childView2:Sprite = new Sprite();
			
			parentView.addChild(childView1);
			parentView.addChild(childView2);
			                                
			var listGiven:Vector.<DisplayObjectContainer> = new <DisplayObjectContainer>[childView2, childView1];
			instance.updateTargets(listGiven);

			var reverseListGiven:Vector.<DisplayObjectContainer> = new <DisplayObjectContainer>[childView1, childView2];
			
			assertFalse("Returns false if no change in targets", instance.updateTargets(reverseListGiven));
		}
		
		public function test_returns_true_if_change_in_targets():void {
			var parentView:Sprite = new Sprite();
			var childView1:Sprite = new Sprite();
			var childView2:Sprite = new Sprite();
			
			parentView.addChild(childView1);
			parentView.addChild(childView2);
			                                
			var listGiven:Vector.<DisplayObjectContainer> = new <DisplayObjectContainer>[childView2, childView1];
			instance.updateTargets(listGiven);

			var differentListGiven:Vector.<DisplayObjectContainer> = new <DisplayObjectContainer>[childView2];
			
			assertTrue("Returns true if change in targets", instance.updateTargets(differentListGiven));
		}
		
		public function test_returns_false_if_first_updated_with_empty_list():void {
			assertFalse("Returns false if first updated with empty list", instance.updateTargets(new <DisplayObjectContainer>[]));
		}
		
		public function test_returns_true_if_updated_empty_list_after_having_content():void {   
			instance.updateTargets(new <DisplayObjectContainer>[new Sprite()]); 
			assertTrue("Returns true if updated empty list after having content", instance.updateTargets(new <DisplayObjectContainer>[]));
		}
		
		public function test_targets_empty_after_updated_with_empty_list():void {
			instance.updateTargets(new <DisplayObjectContainer>[new Sprite()]); 
			instance.updateTargets(new <DisplayObjectContainer>[]);
			assertEquals("Targets empty after updated with empty list", 0, instance.targets.length);
		}
	}
}