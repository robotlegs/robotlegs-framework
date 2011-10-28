package mockolate.ingredients
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
    use namespace mockolate_ingredient;
    
    /**
     * Each Mockolate instances manages the mocking, stubbing, spying and 
     * verifying behaviour of an individual instance prepared and created by 
     * the Mockolate library.
     * 
     * @author drewbourne
     */
    public class Mockolate
    {
//        private var _recorder:RecordingCouverture;
//        private var _stubber:StubbingCouverture;
        private var _mocker:MockingCouverture;
        private var _verifier:VerifyingCouverture;
        
        // flags
        private var _isStrict:Boolean;
        
        // target!
        private var _target:*;
        private var _targetClass:Class;
        
        // identifier
        private var _name:String;
        
        /**
         * Constructor.
         */
        public function Mockolate(name:String=null)
        {
            super();
            
            _name = name;
            _isStrict = true;
        }
        
        /**
         * Name of this Mockolate. 
         */
        public function get name():String
        {
            return _name;
        }
        
//        /**
//         *
//         */
//        mockolate_ingredient function get recorder():RecordingCouverture
//        {
//            return _recorder;
//        }
//        
//        mockolate_ingredient function set recorder(value:RecordingCouverture):void
//        {
//            _recorder = value;
//        }
        
        /**
         * MockingCouverture instance of this Mockolate. 
         */
        mockolate_ingredient function get mocker():MockingCouverture
        {
            return _mocker;
        }
        
        /** @private */
        mockolate_ingredient function set mocker(value:MockingCouverture):void
        {
            _mocker = value;
        }
        
//        /**
//         *
//         */
//        mockolate_ingredient function get stubber():StubbingCouverture
//        {
//            return _stubber;
//        }
//        
//        mockolate_ingredient function set stubber(value:StubbingCouverture):void
//        {
//            _stubber = value;
//        }
        
        /**
         * VerifyingCouverture instance of this Mockolate.
         */
        mockolate_ingredient function get verifier():VerifyingCouverture
        {
            return _verifier;
        }
        
        /** @private */
        mockolate_ingredient function set verifier(value:VerifyingCouverture):void
        {
            _verifier = value;
        }
        
        /**
         * Indicates if this Mockolate is in strict mode. 
         * 
         * Given <code>isStrict</code> is <code>true</code>
         * when a method or property is invoked that does not have a 
         * <code>mock()</code> or <code>stub()</code> expectation set
         * then an ExpectationError will be thrown.
         * 
         * Given <code>isStrict</code> is <code>false</code>
         * when a method or property is invoked that does not have a
         * <code>mock()</code> or <code>stub()</code> expectation set
         * then an appropriate false-y value will be returned.
         *  
         * Eg: <code>false, NaN, 0, null, undefined</code>. 
         */
        mockolate_ingredient function get isStrict():Boolean
        {
            return _isStrict;
        }
        
        /** @private */
        mockolate_ingredient function set isStrict(value:Boolean):void
        {
            _isStrict = value;
        }
        
        /**
         * Reference to the instance this Mockolate is managing.
         */
        mockolate_ingredient function get target():*
        {
            return _target;
        }
        
        /** @private */
        mockolate_ingredient function set target(value:*):void
        {
			
			if (_target)
            {
                throw new ArgumentError("This Mockolate already has a target, received:" + value);
            }
            
            _target = value;            
        }
        
        /**
         * Called when a method or property is invoked on the target instance. 
         */
        mockolate_ingredient function invoked(invocation:Invocation):Mockolate
        {
            // these are specifically this order
            // so that the recording couvertures are invoked
            // prior to any exception possibly being thrown by the mocker, or stubber
            // 
            // this will probably change to a safer and DRYer mechanism shortly
                        
//            if (_recorder)
//                _recorder.invoked(invocation);
            
            if (_verifier)
                _verifier.invoked(invocation);

            if (_mocker)
                _mocker.invoked(invocation);
            
//            if (_stubber)
//                _stubber.invoked(invocation);

			return this;
        }
        
        /**
         * Called when <code>verify(instance)</code> is called. 
         */
        mockolate_ingredient function verify():Mockolate
        {
//            if (_recorder)
//                _recorder.verify();
            
            if (_verifier)
                _verifier.verify();

            if (_mocker)
                _mocker.verify();
            
//            if (_stubber)
//                _stubber.verify();
	
			return this;
        }
    }
}
