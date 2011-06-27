package asunit.framework {
    
    import asunit.errors.AbstractError;
    
    import flash.errors.IllegalOperationError;
    import flash.events.*;
    import flash.net.URLLoader;
    import flash.utils.getTimer;
    
    /**
     * Extend this class if you have a TestCase that requires the
     * asynchronous load of external data.
     */
    public class AsynchronousTestCase extends TestCase implements Test {

        protected static const DEFAULT_REMOTE_TIMEOUT:int = 30000;
        private static const INVALID_TIME:int = -1;
        
        private var _ioErrorExpected:Boolean;
        private var _remoteDuration:int;
        private var _remoteStartTime:int;
        private var _remoteTimeout:int;
        private var _securityErrorExpected:Boolean;
        
        public function AsynchronousTestCase(testMethod:String = null) {
            super(testMethod);
            _remoteStartTime = INVALID_TIME;
            
            // set defaults for user-configurable properties:
            _remoteTimeout = DEFAULT_REMOTE_TIMEOUT;
            _ioErrorExpected = false;
            _securityErrorExpected = false;
        }
        
        public function get remoteDuration():int {
            return _remoteDuration;
        }

        public function remoteDurationIsValid():Boolean {
            return _remoteDuration != INVALID_TIME;
        }
        
        // see testRemoteDuration() below
        public function set remoteTimeout(ms:int):void {
            _remoteTimeout = ms;
        }

        public function set ioErrorExpected(yn:Boolean):void {
            _ioErrorExpected = yn;
        }
        
        public function set securityErrorExpected(yn:Boolean):void {
            _securityErrorExpected = yn;
        }

        // use this method in overriding run() if you are using a URLLoader:
        protected function configureListeners(loader:URLLoader):void {
            loader.addEventListener(Event.COMPLETE, completeHandler);
            loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, httpStatusHandler);
            loader.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
            loader.addEventListener(Event.OPEN, openHandler);
            loader.addEventListener(ProgressEvent.PROGRESS, progressHandler);
            loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        }

        // in a subclass, you should override this method and call super.run() at the end
        public override function run():void {
            if ((this as Object).constructor == AsynchronousTestCase)
            {
                throw new AbstractError("run() method must be overridden in class derived from AsynchronousTestCase");
            }
    
            startRemoteDuration();
        }

        private final function startRemoteDuration():void {
            _remoteStartTime = getTimer();
        }

        private final function setRemoteDuration():void {
            if (_remoteStartTime == INVALID_TIME) {
                // I guess you overrode run() in a subclass without calling super.run()
                _remoteDuration = INVALID_TIME;
            }
            else {
                _remoteDuration = getTimer() - _remoteStartTime;
            }
        }

        protected final function completeHandler(event:Event):void {
            setRemoteDuration();
            setDataSource(event);
            // call super.run() to execute test methods:
            runTests();
        }
        
        // override this method to put a copy of the data into a member reference
        protected function setDataSource(event:Event):void {
            throw new AbstractError("setDataSource must be overridden in class derived from AsynchronousTestCase");
        }
        
        // this method gives derived classes access to TestCase.run()
        protected final function runTests():void {
            super.run();
        }
        
        // TODO: add support for failing status events...
        protected function httpStatusHandler(event:HTTPStatusEvent):void {
            // I believe this is useless except in AIR.
        }

        protected final function ioErrorHandler(event:IOErrorEvent):void {
            result.startTest(this);
            if (_ioErrorExpected == false)
            {
                // access is authorized and we didn't get in: log the error
                result.addError(this, new IllegalOperationError(event.text));
            }
            setRemoteDuration();
            testRemoteDuration();
            dispatchEvent(new Event(Event.COMPLETE));
        }

        protected function openHandler(event:Event):void {
        }

        protected function progressHandler(event:ProgressEvent):void {
        }

        protected final function securityErrorHandler(event:SecurityErrorEvent):void {
            result.startTest(this);
            if (_securityErrorExpected == false)
            {
                // access is authorized and we didn't get in: log the error
                result.addError(this, new IllegalOperationError(event.text));
            }
            setRemoteDuration();
            testRemoteDuration();
            dispatchEvent(new Event(Event.COMPLETE));
        }

        public function testRemoteDuration():void {
            if (!remoteDurationIsValid())
            {
                return;
            }
            if (_remoteDuration > _remoteTimeout)
            {
                result.addError(this, new IllegalOperationError("remote communication took too long: " + _remoteDuration/1000 + " seconds.\n" + this.toString()));
            }
        }

        public function testUnauthorizedAccess():void {
            if (_securityErrorExpected || _ioErrorExpected)
            {
                fail("unauthorized access permitted (expected no access)\n" + this.toString());
            }
        }
        
    }
}