package asunit.textui
{
    import asunit.framework.AsynchronousTestCase;
    import asunit.framework.Test;
    
    public class TestTime extends Object
    {
        public static function create(test:Test, duration:int):TestTime
        {
            var asyncTest:AsynchronousTestCase = test as AsynchronousTestCase;
            if (asyncTest && asyncTest.remoteDurationIsValid())
            {
                return new AsyncTestTime(asyncTest, duration, PrivateConstructorEnforcer);
            }
            else
            {
                return new TestTime(test, duration, PrivateConstructorEnforcer);
            }
        }
        
        private var _name:String;
        private var _duration:int;
        public function get duration():int
        {
            return _duration;
        }
        
        public function TestTime(test:Test, duration:int, lock:Class)
        {
            super();
            if (lock != PrivateConstructorEnforcer)
            {
                throw new Error("TestTime: private constructor");
            }
            
            _name = test.getName();
            _duration = duration;
        }
        
        public function toString():String
        {
            return "" + _duration + 'ms : ' + _name;
        }
        
    }
}
    import asunit.framework.Test;
    import asunit.framework.AsynchronousTestCase;
    import asunit.textui.TestTime;
    

class AsyncTestTime extends TestTime
{
    private var _remoteDuration:int;
    
    public function AsyncTestTime(test:AsynchronousTestCase, duration:int, lock:Class)
    {
        super(test, duration, lock);
        _remoteDuration = test.remoteDuration;
    }
    
    override public function toString():String
    {
        return super.toString() + ' (remote: ' + _remoteDuration + 'ms)';
    }
}

class PrivateConstructorEnforcer {}