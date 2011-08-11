package org.robotlegs.v2.viewmanager.listeningstrategies {

	import asunit.framework.TestCase;
	import flash.display.Sprite;
	import org.robotlegs.v2.viewmanager.IListeningStrategy;
	import flash.display.DisplayObjectContainer;

	public class FewestListenersViewListeningStrategyTest extends TestCase {
		private var instance:FewestListenersViewListeningStrategy;

		public function FewestListenersViewListeningStrategyTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new FewestListenersViewListeningStrategy(null);
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is FewestListenersViewListeningStrategy", instance is FewestListenersViewListeningStrategy);
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
		 
		public function test_returns_nearest_parent_for_sibling_views():void {
			var parentView:Sprite = new Sprite();
			var childView1:Sprite = new Sprite();
			var childView2:Sprite = new Sprite();
			
			parentView.addChild(childView1);
			parentView.addChild(childView2);
			
			instance.updateTargets(new <DisplayObjectContainer>[childView2, childView1]);
			
			assertEquals("Returns nearest parent for sibling views", parentView, instance.targets[0]);
		}
		
		public function test_returns_nearest_grandparent_for_grandsibling_views():void {
			var parentView:Sprite = new Sprite();
			var childView1:Sprite = new Sprite();
			var childView2:Sprite = new Sprite();
			var grandchildView1:Sprite = new Sprite();
			var grandchildView2:Sprite = new Sprite();
			
			parentView.addChild(childView1);
			parentView.addChild(childView2);
			childView1.addChild(grandchildView1);
			childView2.addChild(grandchildView2);
			
			instance.updateTargets(new <DisplayObjectContainer>[grandchildView2, grandchildView1]);
			
			assertEquals("Returns nearest parent for grandsibling views", parentView, instance.targets[0]);
		}
		
		public function test_returns_nearest_parent_for_grandsibling_views_with_common_direct_parent():void {
			var parentView:Sprite = new Sprite();
			var childView1:Sprite = new Sprite();
			var childView2:Sprite = new Sprite();
			var grandchildView1:Sprite = new Sprite();
			var grandchildView2:Sprite = new Sprite();
			
			parentView.addChild(childView1);
			parentView.addChild(childView2);
			childView1.addChild(grandchildView1);
			childView1.addChild(grandchildView2);
			
			instance.updateTargets(new <DisplayObjectContainer>[grandchildView2, grandchildView1]);
			
			assertEquals("Returns nearest parent for grandsibling views with common direct grandparent", childView1, instance.targets[0]);
		} 
		
		public function test_returns_nearest_ancestor_for_grandchild_and_child_views():void {
			var parentView:Sprite = new Sprite();
			var childView1:Sprite = new Sprite();
			var childView2:Sprite = new Sprite();
			var grandchildView1:Sprite = new Sprite();
			
			parentView.addChild(childView1);
			parentView.addChild(childView2);
			childView1.addChild(grandchildView1);
			
			instance.updateTargets(new <DisplayObjectContainer>[childView2, grandchildView1]);
			
			assertEquals("Returns nearest parent for views with common direct grandparent/parent", parentView, instance.targets[0]);
		}
		
		public function test_returns_multiple_results_for_targets_with_no_common_ancestor():void { 
			var parentView_A:Sprite = new Sprite();
			var childView_A1:Sprite = new Sprite();
			var grandchildView_A1:Sprite = new Sprite();
			var grandchildView_A2:Sprite = new Sprite();

			var parentView_B:Sprite = new Sprite();
			var childView_B1:Sprite = new Sprite();
			var childView_B2:Sprite = new Sprite();
			
			parentView_A.addChild(childView_A1);
			childView_A1.addChild(grandchildView_A1);
			childView_A1.addChild(grandchildView_A2);

			parentView_B.addChild(childView_B1);
			parentView_B.addChild(childView_B2);
			
			instance.updateTargets(new <DisplayObjectContainer>[childView_A1, grandchildView_A2, childView_B1, childView_B2]);
			assertEqualsVectorsIgnoringOrder("Returns multiple results for targets with no common ancestor", 
																new <DisplayObjectContainer>[parentView_B, childView_A1], instance.targets);
		} 
		
		public function test_returns_submitted_value_if_one_value_is_submitted():void {
			var parentView:Sprite = new Sprite();
			 
			instance.updateTargets(new <DisplayObjectContainer>[parentView]);
			
			assertEquals("Returns parent if parent is submitted -> not implemented", parentView, instance.targets[0]);
		}
		
		public function test_returns_submitted_value_if_it_is_ancestor_to_other_values():void {
			var parentView:Sprite = new Sprite();
			var childView1:Sprite = new Sprite();
			var childView2:Sprite = new Sprite();
			var grandchildView1:Sprite = new Sprite();
			
			parentView.addChild(childView1);
			parentView.addChild(childView2);
			childView1.addChild(grandchildView1);
			
			instance.updateTargets(new <DisplayObjectContainer>[childView2, grandchildView1, parentView]);
			
			assertEquals("Returns submitted value if it is ancestor to other values", parentView, instance.targets[0]);
		} 
		
		public function test_returns_false_if_no_change_in_roots_even_with_different_search_values():void {
			var parentView_A:Sprite = new Sprite();
			var childView_A1:Sprite = new Sprite();
			var grandchildView_A1:Sprite = new Sprite();
			var grandchildView_A2:Sprite = new Sprite();

			var parentView_B:Sprite = new Sprite();
			var childView_B1:Sprite = new Sprite();
			var childView_B2:Sprite = new Sprite();
			
			parentView_A.addChild(childView_A1);
			childView_A1.addChild(grandchildView_A1);
			childView_A1.addChild(grandchildView_A2);

			parentView_B.addChild(childView_B1);
			parentView_B.addChild(childView_B2);

			instance.updateTargets(new <DisplayObjectContainer>[childView_A1, grandchildView_A2, childView_B1, childView_B2]);
			
			var changed:Boolean = instance.updateTargets(new <DisplayObjectContainer>[childView_A1, grandchildView_A2, parentView_B]);
			
			assertFalse("Returns false if no change in roots even with different search values", changed);
		}
		
		public function test_returns_true_if_change_in_roots_even_with_same_search_values():void {
			var parentView_A:Sprite = new Sprite();
			var childView_A1:Sprite = new Sprite();
			var grandchildView_A1:Sprite = new Sprite();
			var grandchildView_A2:Sprite = new Sprite();

			var parentView_B:Sprite = new Sprite();
			var childView_B1:Sprite = new Sprite();
			var childView_B2:Sprite = new Sprite();
			
			parentView_A.addChild(childView_A1);
			childView_A1.addChild(grandchildView_A1);
			childView_A1.addChild(grandchildView_A2);

			parentView_B.addChild(childView_B1);
			parentView_B.addChild(childView_B2);

			instance.updateTargets(new <DisplayObjectContainer>[childView_A1, grandchildView_A2, childView_B1, childView_B2]);
			
			parentView_A.addChild(childView_B1);
			
			var changed:Boolean = instance.updateTargets(new <DisplayObjectContainer>[childView_A1, grandchildView_A2, childView_B1]);
			
			assertTrue("Returns true if change in roots even with same search values", changed);
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