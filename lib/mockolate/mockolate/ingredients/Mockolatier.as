package mockolate.ingredients
{
    import asx.array.flatten;
    
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.utils.Dictionary;
    import flash.utils.setTimeout;
    
    import mockolate.errors.MockolateError;
    import mockolate.ingredients.floxy.FloxyMockolateFactory;
    
    import org.hamcrest.Matcher;
    import org.hamcrest.collection.emptyArray;
    import org.hamcrest.collection.everyItem;
    import org.hamcrest.core.isA;
    import org.hamcrest.core.not;
    
    use namespace mockolate_ingredient;
    
    /**
     * Maker of the Mockolates.
     * 
     * Used by MockolatierMaster and the <code>mockolate.*</code> package-level functions.
     * 
     * Do not reference directly.  
     * 
     * @author drewbourne
     */
    public class Mockolatier extends EventDispatcher
    {
        // instance
        
        private var _mockolates:Array;
        private var _mockolatesByTarget:Dictionary;
        private var _mockolateFactory:MockolateFactory;
        
        /**
         * Constructor.
         */
        public function Mockolatier()
        {
            super();
            
            _mockolates = [];
            _mockolatesByTarget = new Dictionary();
            _mockolateFactory = new FloxyMockolateFactory();
        }

		// TODO implement Mockolatier#hasPrepared(Class)        
//        /**
//         * Indicates if the given Class has been prepared by this Mockolatier instance.
//         */
//        public function hasPrepared(klass:Class):Boolean
//        {
//            return false;
//        }
        
        /**
         * Prepares the given Class references for creating proxy instances. 
         *  
         * @see mockolate#prepare()
         */
        public function prepare(... rest):IEventDispatcher
        {
            // deal with nested arrays of Classes
            var classes:Array = flatten(rest);
            
            // nothing to do, have a whinge. 
            check(classes, not(emptyArray()), "Mockolatier requires some ingredients to prepare, received none.");
            
            // built-in types cannot be proxied.
            // TODO include only the types in the error message that could not be proxied. 
            // check(rest, everyItem(not(builtInType())), "Mockolatier can not prepare with built-in Classes, received " + rest.join(', '));
            
            // TODO we could get the types of the instances, and attempt to proxy them
            check(classes, everyItem(isA(Class)), "Mockolatier can only prepare Classes, received " + classes.join(', '));
            
            // pass the classes to the MockolateFactory to do the hard work 
            var preparing:IEventDispatcher = _mockolateFactory.prepare.apply(null, classes);
            preparing.addEventListener(Event.COMPLETE, prepareCompleted, false, 0, true);
            
            return this;
        }
        
        /**
         * @private
         */
        protected function prepareCompleted(event:Event):void
        {
            // TODO also pass in the classes that were prepared?
            
            // at the moment the Floxy ProxyRepository immediately fires the completed event
            // when there are no classes to prepare. as such without making it asynchronous 
            // then any listeners added to the Mockolatier for Event.COMPLETE will not be triggered. 
            
            setTimeout(dispatchEvent, 10, event);
        }
        
        /**
         * @private
         */
        public function nice(klass:Class, name:String=null, constructorArgs:Array=null):*
        {
            return createTarget(klass, constructorArgs, false, name);
        }
        
        /**
         * @private
         */
        public function strict(klass:Class, name:String=null, constructorArgs:Array=null):*
        {
            return createTarget(klass, constructorArgs, true, name);
        }

        /**
         * @private
         */
        public function mock(instance:*):MockingCouverture
        {
            return mockolateByTarget(instance).mocker.mock();
        }
        
        /**
         * @private
         */
        public function stub(instance:*):MockingCouverture
        {
            return mockolateByTarget(instance).mocker.stub();
        }
        
        /**
         * @private
         */
        public function verify(instance:*):VerifyingCouverture
        {
        	return mockolateByTarget(instance).verify().verifier;
        }
        
        /**
         * Checks the args Array matches the given Matcher, throws an ArgumentError if not.
         *
         * @param args
         * @param matcher
         * @param errorMessage
         * @throw ArgumentError
         */
        protected function check(args:Array, matcher:Matcher, errorMessage:String):void
        {
            if (!matcher.matches(args))
            {
                throw new ArgumentError(errorMessage);
            }
        }
        
        /**
         * Creates a proxied instance of the given Class and an associated 
         * Mockolate instance.
         * 
         * @param klass
         * @param constructorArgs
         * @param asStrict
         * @param name  
         * 
         * @private
         */
        protected function createTarget(klass:Class, constructorArgs:Array=null, asStrict:Boolean=true, name:String=null):*
        {
            var mockolate:Mockolate = _mockolateFactory.create(klass, constructorArgs, asStrict, name);
			var target:* = mockolate.target;
            // store
            _mockolates.push(mockolate);
            _mockolatesByTarget[target] = mockolate;
            
            return target;
        }
        
        /**
         * Finds a Mockolate instance by its target instance.
         * 
         * Throws a MockolateNotFoundError when there is no Mockolate for the given target. 
         * 
         * @private
         */
        protected function mockolateByTarget(target:*):Mockolate
        {
            var mockolate:Mockolate = _mockolatesByTarget[target];
            if (!mockolate)
                throw new MockolateError(
					["No Mockolate for that target, received:{}", [target]], 
					null, target);
            
            return mockolate;
        }
    }
}
