package asunit.framework {
    
    import flash.utils.getTimer;
    
    /**
     * A <code>TestFailure</code> collects a failed test together with
     * the caught exception.
     * @see TestResult
     */
    public class TestMethod {
        protected var test:Test;
        protected var method:String;
        
        private var _duration:Number;
        private var start:Number;
        
        /**
         * Constructs a TestMethod with a given Test and method name.
         */
        public function TestMethod(test:Test, method:String) {
            this.test = test;
            this.method = method;
            start = getTimer();
        }
        
        public function getName():String {
            return method;
        }
        
        public function endTest(test:Test):void {
            _duration = (getTimer() - start) * .001;
        }
        
        public function duration():Number {
            return _duration;
        }
    }
}