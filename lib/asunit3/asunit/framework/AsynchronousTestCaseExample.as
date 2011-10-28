package asunit.framework {
    import flash.events.*;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    
    /**
     * This example is built on the following mock data:
     * <books>
     *         <book publisher="Addison-Wesley" name="Design Patterns" />
     *         <book publisher="Addison-Wesley" name="The Pragmattic Programmer" />
     *         <book publisher="Addison-Wesley" name="Test Driven Development" />
     *         <book publisher="Addison-Wesley" name="Refactoring to Patterns" />
     *         <book publisher="O'Reilly Media" name="The Cathedral & the Bazaar" />
     *         <book publisher="O'Reilly Media" name="Unit Test Frameworks" />
     *     </books>
     * 
     * This example was created to illustrate how one can build an synchronous
     * TestCase - one that relies on remote data of some sort.
     * This use case is now diminished by the creation of E4X and easily
     * readable/editable XML data directly in source form.
     * But asynchronous tests will probably need to be built at some point
     * by somebody... If you're them, maybe you can use this as a template.
     */

    public class AsynchronousTestCaseExample extends AsynchronousTestCase {
        private var source:String = "asunit/framework/MockData.xml";
        private var dataSource:XML;
        private var instance:Object;

        // Override the run method and begin the request for remote data
        public override function run():void {
            var request:URLRequest = new URLRequest(source);
            var loader:URLLoader = new URLLoader();
            // configureListeners is a method on the AsynchronousTestCase
            // and it will handle error states by failing loudly...
            configureListeners(loader);
            loader.load(request);
            
            // call super.run() to start network duration:
            super.run();
        }

        protected override function setDataSource(event:Event):void {
            // put a copy of the data into a member reference
            if (event == null)
            {
                dataSource = null;
            }
            else
            {
                dataSource = XML(event.target.data).copy();
            }
        }
        
        protected override function setUp():void {
            // create a new instance of the class under test
            instance = new Object();
            if (dataSource != null)    // i.e. there was no IOError or SecurityError
            {
                // copy the data into a member or method of the _instance
                instance.data = dataSource.copy();
            }
        }
        
        protected override function tearDown():void {
            // destroy the class under test instance
            instance = null;
        }
        
        public function testBookCount():void {
            var data:XML = XML(instance.data);
            var list:XMLList = data..book;
            assertTrue("list.length() == " + list.length() + " (6?)", list.length() == 6);
        }
        
        public function testOReillyBookCount():void {
            var data:XML = XML(instance.data);
            var list:XMLList = data..book.(@publisher == "O'Reilly Media");
            assertTrue("list.length() == " + list.length() + " (2?)", list.length() == 2);            
        }
    }
}