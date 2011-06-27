package mockolate.ingredients
{
    import asx.array.empty;
    import asx.fn._;
    import asx.fn.partial;
    
    import mockolate.errors.VerificationError;
    
    import org.hamcrest.Matcher;
    import org.hamcrest.collection.array;
    import org.hamcrest.collection.arrayWithSize;
    import org.hamcrest.collection.emptyArray;
    import org.hamcrest.core.anyOf;
    import org.hamcrest.date.dateEqual;
    import org.hamcrest.number.greaterThan;
    import org.hamcrest.number.lessThan;
    import org.hamcrest.object.equalTo;
    import org.hamcrest.object.hasProperties;
    import org.hamcrest.object.hasProperty;
    import org.hamcrest.text.re;
    
    use namespace mockolate_ingredient;
    
    /**
     * Provides a Test Spy API.
     * 
     * @author drewbourne
     */
    public class VerifyingCouverture extends RecordingCouverture
    {
        private var _currentVerification:Verification;
        
        /**
         * Constructor.
         */
        public function VerifyingCouverture(mockolate:Mockolate)
        {
            super(mockolate);
        }
        
        /**
         * Verifies if a method with the given name was invoked. 
         * 
         * @example
         * <listing version="3.0">
         * 	verify(instance).method("toString");
         * </listing>
         */
        public function method(name:String/*, ns:String=null*/):VerifyingCouverture
        {
            _currentVerification = new Verification();
            _currentVerification.invocationType = InvocationType.METHOD;
            _currentVerification.invocationTypeMatcher = hasProperty("invocationType", InvocationType.METHOD);
            _currentVerification.name = name;
            _currentVerification.nameMatcher = hasProperty("name", name);
                        
            doVerify();
            return this;
        }
        
        /**
         * Verifies if a property getter with the given name was invoked. 
         * 
         * @example
         * <listing version="3.0">
         * 	verify(instance).getter("toString");
         * </listing>
         */
        public function getter(name:String/*, ns:String=null*/):VerifyingCouverture
        {
            _currentVerification = new Verification();
            _currentVerification.invocationType = InvocationType.GETTER;
            _currentVerification.invocationTypeMatcher = hasProperty("invocationType", InvocationType.GETTER);
            _currentVerification.name = name;
            _currentVerification.nameMatcher = hasProperty("name", name);
            
            doVerify();
            return this;
        }        
        
        /**
         * Verifies if a property setter with the given name was invoked. 
         * 
         * @example
         * <listing version="3.0">
         * 	verify(instance).getter("toString");
         * </listing>
         */
        public function setter(name:String/*, ns:String=null*/):VerifyingCouverture
        {
            _currentVerification = new Verification();
            _currentVerification.invocationType = InvocationType.SETTER;
            _currentVerification.invocationTypeMatcher = hasProperty("invocationType", InvocationType.SETTER);
            _currentVerification.name = name;
            _currentVerification.nameMatcher = hasProperty("name", name);
            
            doVerify();
            return this;
        }

		/**
         * Verifies if a method or property was invoked with the given argument value. 
         * 
         * @example
         * <listing version="3.0">
         * 	verify(instance).method("enabled").arg(true);
         * </listing>
         */        
        public function arg(value:Object):VerifyingCouverture
        {
        	return args(value);
        }
        
		/**
         * Verifies if a method or property was invoked with the given argument value. 
         * 
         * @example
         * <listing version="3.0">
         * 	verify(instance).property("enabled").arg(true);
         * </listing>
         */         
        public function args(... rest):VerifyingCouverture
        {
        	// FIXME ensure there is a currentVerification
        	
            if (_currentVerification.invocationType == InvocationType.GETTER)
                throw new VerificationError(
                	"getters do not accept arguments", 
                	_currentVerification, mockolate, mockolate.target);
            
            _currentVerification.arguments = rest;
            _currentVerification.argumentsMatcher = hasProperty("arguments", array(rest.map(partial(valueToMatcher, _))));
            
            doVerify();
            return this;
        }
        
        public function noArgs():VerifyingCouverture
        {
            if (_currentVerification.invocationType == InvocationType.GETTER)
                throw new VerificationError(
                	"getters do not accept arguments", 
                	_currentVerification, mockolate, mockolate.target);
            
            _currentVerification.arguments = null;
            _currentVerification.argumentsMatcher = hasProperty("arguments", emptyArray());
        	
        	doVerify();
        	return this;
        }
        
		/**
         * Verifies if a method or property was invoked the given number of times. 
         * 
         * @example
         * <listing version="3.0">
         * 	verify(instance).property("enabled").times(2);
         * </listing>
         */   
		public function times(n:int):VerifyingCouverture
        {
            _currentVerification.invokedCount = n.toString();
            _currentVerification.invokedCountMatcher = arrayWithSize(n);
            
            doVerify();
            return this;
        }
        
        /**
         * Verifies if a method or property was not invoked. 
         * 
         * @example
         * <listing version="3.0">
         * 	verify(instance).property("enabled").never();
         * </listing>
         */
        public function never():VerifyingCouverture
        {
            return times(0);
        }
        
        /**
         * Verifies if a method or property was invoked one time. 
         * 
         * @example
         * <listing version="3.0">
         * 	verify(instance).property("enabled").once();
         * </listing>
         */ 
        public function once():VerifyingCouverture
        {
            return times(1);
        }
        
        /**
         * Verifies if a method or property was invoked two times. 
         * 
         * @example
         * <listing version="3.0">
         * 	verify(instance).property("enabled").twice();
         * </listing>
         */ 
        public function twice():VerifyingCouverture
        {
            return times(2);
        }
        
        // at the request of Brian LeGros we have thrice()
        /**
         * Verifies if a method or property was invoked three times. 
         * 
         * @example
         * <listing version="3.0">
         * 	verify(instance).property("enabled").thrice();
         * </listing>
         */ 
        public function thrice():VerifyingCouverture
        {
            return times(3);
        }
        
        /**
         * Verifies if a method or property was invoked at least the given number of times. 
         * 
         * @example
         * <listing version="3.0">
         * 	verify(instance).property("enabled").atLeast(2);
         * </listing>
         */
        public function atLeast(n:int):VerifyingCouverture
        {
            _currentVerification.invokedCount = "at least " + n;
            _currentVerification.invokedCountMatcher = arrayWithSize(greaterThan(n));
            
            doVerify();
            return this;
        }
        
        /**
         * Verifies if a method or property was invoked at most the given number of times. 
         * 
         * @example
         * <listing version="3.0">
         * 	verify(instance).property("enabled").atMost(2);
         * </listing>
         */
        public function atMost(n:int):VerifyingCouverture
        {
            _currentVerification.invokedCount = "at most " + n;
            _currentVerification.invokedCountMatcher = arrayWithSize(lessThan(n)); 
                  
            doVerify();
            return this;
        }
        
        // TODO sequenced(sequence:Sequence):VerifyingCouverture
        // TODO ordererd(group:String):VerifyingCouverture
        
        /**
         * @private
         */
        override mockolate_ingredient function verify():void
        {
        
        }
        
        /**
         * Converts a value to a Matcher for use when matching Invocation arguments. 
         *  
         * @private
         */
        protected function valueToMatcher(value:*):Matcher
        {
            if (value is RegExp)
            {
                return anyOf(equalTo(value), re(value as RegExp));
            }
            
            if (value is Date)
            {
                return anyOf(equalTo(value), dateEqual(value));
            }
            
            if (value is Matcher)
            {
                return value as Matcher;
            }
            
            return equalTo(value);
        }
        
        /**
         * Verifies that the expected Invocations have been recorded. 
         * 
         * @private 
         */     
        protected function doVerify():void
        {
            var matchingInvocations:Array = invocations;
            
            if (_currentVerification.invocationTypeMatcher)
            {
                matchingInvocations = matchingInvocations.filter(partial(_currentVerification.invocationTypeMatcher.matches, _));
                failIfEmpty(matchingInvocations, "no invocations as " + _currentVerification.invocationType);
            }

            if (_currentVerification.nameMatcher)
            {            
                matchingInvocations = matchingInvocations.filter(partial(_currentVerification.nameMatcher.matches, _));
                failIfEmpty(matchingInvocations, "no invocations with name " + _currentVerification.name);
            }
            
            if (_currentVerification.argumentsMatcher)
            {
                matchingInvocations = matchingInvocations.filter(partial(_currentVerification.argumentsMatcher.matches, _));
                failIfEmpty(matchingInvocations, "no invocations with arguments " + _currentVerification.arguments);
            }
            
            if (_currentVerification.invokedCountMatcher)
            {
                if (!_currentVerification.invokedCountMatcher.matches(matchingInvocations))
                {
                    fail("no invocations received " + _currentVerification.invokedCount + " times ");
                }
            }
        }
        
        /**
         * @private 
         */
        protected function failIfEmpty(array:Array, description:String):void 
        {
            if (empty(array))
            {
                fail(description);       
            } 
        }
        
        /**
         * @private 
         */
        protected function fail(description:String):void 
        {
            throw new VerificationError(
            	description, _currentVerification, mockolate, mockolate.target);    
        }
    }
}
