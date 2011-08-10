package org.robotlegs.v2.viewmanager.listeningstrategies {

	import asunit.framework.TestCase;
	import org.robotlegs.v2.viewmanager.IViewListeningStrategy;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;

	public class StageViewListeningStrategyTest extends TestCase {
		private var instance:StageViewListeningStrategy; 
		private const STAGE_ACCESS_SPRITE:Sprite = new Sprite();

		public function StageViewListeningStrategyTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new StageViewListeningStrategy();
			addChild(STAGE_ACCESS_SPRITE);
		}

		override protected function tearDown():void {
			super.tearDown();
			removeChild(STAGE_ACCESS_SPRITE);
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is StageViewListeningStrategy", instance is StageViewListeningStrategy);
		}  
		
		public function test_implements_IViewListeningStrategy():void {
			assertTrue("Implements IViewListeningStrategy", instance is IViewListeningStrategy);
		}

		public function testFailure():void {
			assertTrue("Failing test", true);
		}                                          
		
		public function test_targets_initially_empty():void {
			assertEquals("Targets initially empty", 0, instance.targets.length);
		}
		
		public function test_targets_returns_stage_of_passed_item():void {
			instance.updateTargets(new <DisplayObjectContainer>[STAGE_ACCESS_SPRITE]);
			assertEquals("Returns stage of passed item", STAGE_ACCESS_SPRITE.stage, instance.targets[0]);
		}      
		
		public function test_targets_length_1_even_if_multiple_items_passed():void {
			var extraSprite:Sprite = new Sprite();
			addChild(extraSprite);
			instance.updateTargets(new <DisplayObjectContainer>[STAGE_ACCESS_SPRITE, extraSprite]);
			
			assertEquals("Targets length 1 even if multiple items passed", 1, instance.targets.length);
			removeChild(extraSprite);
		}
		
		public function test_returns_true_when_first_set_with_value():void {
			assertTrue("Returns true when first set with value", instance.updateTargets(new <DisplayObjectContainer>[STAGE_ACCESS_SPRITE]));
		}                                               
		
		public function test_returns_false_when_updated_with_content():void {
			instance.updateTargets(new <DisplayObjectContainer>[STAGE_ACCESS_SPRITE]); 
			var extraSprite:Sprite = new Sprite();
			addChild(extraSprite);
			
			assertFalse("Returns false when updated with content", instance.updateTargets(new <DisplayObjectContainer>[STAGE_ACCESS_SPRITE, extraSprite]));
		} 
		
		public function test_returns_false_if_first_updated_with_empty_list():void {
			assertFalse("Returns false if first updated with empty list", instance.updateTargets(new <DisplayObjectContainer>[]));
		}
		
		public function test_returns_true_if_updated_empty_list_after_having_content():void {   
			instance.updateTargets(new <DisplayObjectContainer>[STAGE_ACCESS_SPRITE]); 
			assertTrue("Returns true if updated empty list after having content", instance.updateTargets(new <DisplayObjectContainer>[]));
		}
		
		public function test_targets_empty_after_updated_with_empty_list():void {
			instance.updateTargets(new <DisplayObjectContainer>[STAGE_ACCESS_SPRITE]); 
			instance.updateTargets(new <DisplayObjectContainer>[]);
			assertEquals("Targets empty after updated with empty list", 0, instance.targets.length);
		}
	}
}