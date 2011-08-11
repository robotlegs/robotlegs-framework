package org.robotlegs.v2.viewmanager {

	import asunit.framework.TestCase;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.Event;

	public class ListenerMapTest extends TestCase {
		private var instance:ListenerMap;
		protected const EVENT_TYPE:String = "blah"; 
		
		protected var _targetsFired:Vector.<IEventDispatcher>;

		public function ListenerMapTest(methodName:String=null) {
			super(methodName)
		}

		override protected function setUp():void {
			super.setUp();
			instance = new ListenerMap(EVENT_TYPE, callback, false);  
			_targetsFired = new Vector.<IEventDispatcher>();
		}

		override protected function tearDown():void {
			super.tearDown();
			instance = null;
		}

		public function testInstantiated():void {
			assertTrue("instance is ListenerMap", instance is ListenerMap);
		}

		public function testFailure():void {
			assertTrue("Failing test", true);
		} 
		
		public function test_listeners_originally_set():void { 
			var target1:IEventDispatcher = new EventDispatcher();
			var target2:IEventDispatcher = new EventDispatcher();
			
			var targets:Vector.<IEventDispatcher> = new <IEventDispatcher>[target1, target2];
			instance.updateListenerTargets(targets);
			
			assertTrue("Listeners originally set 1", target1.hasEventListener(EVENT_TYPE));
			assertTrue("Listeners originally set 2", target2.hasEventListener(EVENT_TYPE));
		} 
		
		public function test_listeners_updated_to_remove_from_old_and_add_to_new():void { 
			var target1:IEventDispatcher = new EventDispatcher();
			var target2:IEventDispatcher = new EventDispatcher();
			
			var targets:Vector.<IEventDispatcher> = new <IEventDispatcher>[target1, target2];
			instance.updateListenerTargets(targets);
			
			var target_new:IEventDispatcher = new EventDispatcher();
			
			var targets2:Vector.<IEventDispatcher> = new <IEventDispatcher>[target2, target_new];
			
			instance.updateListenerTargets(targets2);
			
			assertFalse("Listener not present where no longer in list", target1.hasEventListener(EVENT_TYPE));
			assertTrue("Listener persisted for item in old and new lists", target2.hasEventListener(EVENT_TYPE));
			assertTrue("Listener added to item added to list", target_new.hasEventListener(EVENT_TYPE));
		}  
		
		public function test_callbacks_only_fire_once_per_target_even_if_added_twice():void {
			var target1:IEventDispatcher = new EventDispatcher();
			var target2:IEventDispatcher = new EventDispatcher();
			
			var targets:Vector.<IEventDispatcher> = new <IEventDispatcher>[target1, target2];
			instance.updateListenerTargets(targets);
			
			var target_new:IEventDispatcher = new EventDispatcher();
			
			var targets2:Vector.<IEventDispatcher> = new <IEventDispatcher>[target2, target_new];
			
			instance.updateListenerTargets(targets2);

			target2.dispatchEvent(new Event(EVENT_TYPE));

			assertEquals("Callbacks only fire once per target even if added twice", 
																1, _targetsFired.length);
		}
		
		
		protected function callback(e:Event):void
		{ 
			trace("ListenerMapTest::callback()");
			_targetsFired.push(e.target);
		}
		
		
	}
}