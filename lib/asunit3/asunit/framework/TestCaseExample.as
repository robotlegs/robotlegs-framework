package asunit.framework {
    import asunit.framework.TestCase;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.events.EventDispatcher;
    import flash.utils.setTimeout;

    // TestCase subclasses should always end with 'Test', the example
    // doesn't because we don't want TestSuites in this directory.
    public class TestCaseExample extends TestCase {
        private var date:Date;
        private var sprite:Sprite;

        // TestCase constructors must be implemented as follows
        // so that we can execute a single method on them from
        // the TestRunner
        public function TestCaseExample(testMethod:String = null) {
            super(testMethod);
        }

        // This method will be called before every test method
        override protected function setUp():void {
            date = new Date();
//            sprite = new Sprite();
//            addChild(sprite);
        }

        // This method will be called after every test method
        // but only if we're executing the entire TestCase,
        // the tearDown method won't be called if we're
        // calling start(MyTestCase, "someMethod");
        override protected function tearDown():void {
//            removeChild(sprite);
//            sprite = null;
            date = null;
        }

        // This is auto-created by the XULUI and ensures that
        // our objects are actually created as we expect.
        public function testInstantiated():void {
            assertTrue("Date instantiated", date is Date);
//            assertTrue("Sprite instantiated", sprite is Sprite);
        }

        // This is an example of a typical test method
        public function testMonthGetterSetter():void {
            date.month = 1;
            assertEquals(1, date.month);
        }

        // This is an asynchronous test method
        public function testAsyncFeature():void {
            // create a new object that dispatches events...
            var dispatcher:IEventDispatcher = new EventDispatcher();
            // get a TestCase async event handler reference
            // the 2nd arg is an optional timeout in ms. (default=1000ms )
            var handler:Function = addAsync(changeHandler, 2000);
            // subscribe to your event dispatcher using the returned handler
            dispatcher.addEventListener(Event.CHANGE, handler);
            // cause the event to be dispatched.
            // either immediately:
            //dispatcher.dispatchEvent(new Event(Event.CHANGE));
            // or in the future < your assigned timeout
            setTimeout( dispatcher.dispatchEvent, 200, new Event(Event.CHANGE));
        }

        protected function changeHandler(event:Event):void {
            // perform assertions in your handler
            assertEquals(Event.CHANGE, event.type);
        }
    }
}
