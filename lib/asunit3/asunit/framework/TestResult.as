package asunit.framework {
    import asunit.errors.AssertionFailedError;
    import asunit.errors.InstanceNotFoundError;
    
    /**
     * A <code>TestResult</code> collects the results of executing
     * a test case. It is an instance of the Collecting Parameter pattern.
     * The test framework distinguishes between <i>failures</i> and <i>errors</i>.
     * A failure is anticipated and checked for with assertions. Errors are
     * unanticipated problems like an <code>ArrayIndexOutOfBoundsException</code>.
     *
     * @see Test
     */
    public class TestResult implements TestListener {
        protected var fFailures:Array;
        protected var fErrors:Array;
        protected var fListeners:Array;
        protected var fRunTests:int;
        private var fStop:Boolean;
        
        public function TestResult() {
            fFailures  = new Array();
            fErrors       = new Array();
            fListeners = new Array();
            fRunTests  = 0;
            fStop       = false;
        }
        /**
         * Adds an error to the list of errors. The passed in exception
         * caused the error.
         */
        public function addError(test:Test, t:Error):void {
            fErrors.push(new TestFailure(test, t));
            var len:uint = fListeners.length;
            var item:TestListener;
            for(var i:uint; i < len; i++) {
                item = TestListener(fListeners[i]);
                item.addError(test, t);
            }
        }
        /**
         * Adds a failure to the list of failures. The passed in exception
         * caused the failure.
         */
        public function addFailure(test:Test, t:AssertionFailedError):void {
            fFailures.push(new TestFailure(test, t));
            var len:uint = fListeners.length;
            var item:TestListener;
            for(var i:uint; i < len; i++) {
                item = TestListener(fListeners[i]);
                item.addFailure(test, t);
            }
        }
        /**
         * Registers a TestListener
         */
        public function addListener(listener:TestListener):void {
            fListeners.push(listener);
        }
        /**
         * Unregisters a TestListener
         */
        public function removeListener(listener:TestListener):void {
            var len:uint = fListeners.length;
            for(var i:uint; i < len; i++) {
                if(fListeners[i] == listener) {
                    fListeners.splice(i, 1);
                    return;
                }
            }
            throw new InstanceNotFoundError("removeListener called without listener in list");
        }
        /**
         * Gets the number of detected errors.
         */
        public function errorCount():int {
            return fErrors.length;
        }
        /**
         * Returns an Enumeration for the errors
         */
        public function errors():Array {
            return fErrors;
        }
        /**
         * Gets the number of detected failures.
         */
        public function failureCount():int {
            return fFailures.length;
        }
        /**
         * Returns an Enumeration for the failures
         */
        public function failures():Array {
            return fFailures;
        }
        
        /**
         * Runs a TestCase.
         */
        public function run(test:Test):void {
			startTest(test);
            test.runBare();
        }
        /**
         * Gets the number of run tests.
         */
        public function runCount():int {
            return fRunTests;
        }
        /**
         * Checks whether the test run should stop
         */
        public function shouldStop():Boolean {
            return fStop;
        }
        /**
         * Informs the result that a test will be started.
         */
        public function startTest(test:Test):void {
            var count:int = test.countTestCases();
            fRunTests += count;
            var len:uint = fListeners.length;
            var item:TestListener;
            for(var i:uint; i < len; i++) {
                item = TestListener(fListeners[i]);
                item.startTest(test);
            }
        }
        
        public function startTestMethod(test:Test, method:String):void {
            var len:uint = fListeners.length;
            var item:TestListener;
            for(var i:uint; i < len; i++) {
                item = TestListener(fListeners[i]);
                item.startTestMethod(test, method);
            }
        }
        
        public function endTestMethod(test:Test, method:String):void {
            var len:uint = fListeners.length;
            var item:TestListener;
            for(var i:uint; i < len; i++) {
                item = TestListener(fListeners[i]);
                item.endTestMethod(test, method);
            }
        }
        
        /**
         * Informs the result that a test was completed.
         */
        public function endTest(test:Test):void {
            var len:uint = fListeners.length;
            var item:TestListener;
            for(var i:uint; i < len; i++) {
                item = TestListener(fListeners[i]);
                item.endTest(test);
            }
        }
        /**
         * Marks that the test run should stop.
         */
        public function stop():void {
            fStop = true;
        }
        /**
         * Returns whether the entire test was successful or not.
         */
        public function wasSuccessful():Boolean {
            return failureCount() == 0 && errorCount() == 0;
        }
    }
}