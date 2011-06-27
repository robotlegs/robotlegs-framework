package asunit.textui {
    import asunit.framework.TestResult;    
    
    import mx.core.WindowedApplication;
    
    /**
    *   The base class for Air application runners that use the Flex framework.
    *   
    *   @includeExample AirRunnerExample.mxml
    *   
    *   @author Ian
    *   @playerversion AIR 1.1
    **/
    public class AirRunner extends WindowedApplication {
        
        protected var runner:TestRunner;

        override protected function createChildren():void {
            super.createChildren();
            runner = new FlexTestRunner();
            rawChildren.addChild(runner);
        }
        
        public function start(testCase:Class, testMethod:String = null, showTrace:Boolean = false) : TestResult {
            return runner.start(testCase, testMethod, showTrace);
        }        
    }
}
