package asunit.framework {
    import asunit.errors.AssertionFailedError;
    
    /**
     * A <code>TestFailure</code> collects a failed test together with
     * the caught exception.
     * @see TestResult
     */
    public class TestFailure {
        protected var fFailedTest:Test;
        protected var fFailedTestMethod:String;
        protected var fThrownException:Error;
        
        /**
         * Constructs a TestFailure with the given test and exception.
         */
        public function TestFailure(failedTest:Test, thrownException:Error) {
            fFailedTest = failedTest;
            fFailedTestMethod = failedTest.getCurrentMethod();
            fThrownException = thrownException;
        }
        
        public function failedFeature():String {
            return failedTest().getName() + '.' + fFailedTestMethod;
        }
        
        public function failedMethod():String {
            return fFailedTestMethod;
        }
        
        /**
         * Gets the failed test case.
         */
        public function failedTest():Test {
            return fFailedTest;
        }
        /**
         * Gets the thrown exception.
         */
        public function thrownException():Error {
            return fThrownException;
        }
        /**
         * Returns a short description of the failure.
         */
        public function toString():String {
            return "";
        }

        public function exceptionMessage():String {
            return thrownException().message;
        }

        public function isFailure():Boolean {
            return thrownException() is AssertionFailedError;
        }
    }
}