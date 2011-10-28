package asunit.textui {
    import asunit.framework.TestResult;
    
    import mx.core.Application;
    
    /**
    *   The <code>FlexTestRunner</code> should be the base class for your 
    *   test harness if you're testing a project that uses Flex components.
    *   
    *   @includeExample FlexRunnerExample.mxml
    **/
    public class FlexRunner extends Application {
        protected var runner:TestRunner;

        override protected function createChildren():void {
            super.createChildren();
            runner = new FlexTestRunner();
            rawChildren.addChild(runner);
        }
        
        public function start(testCase:Class, testMethod:String = null, showTrace:Boolean = false):TestResult {
            return runner.start(testCase, testMethod, showTrace);
        }
    }
}
