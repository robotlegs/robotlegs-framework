package mockolate.ingredients
{
    import flash.events.IEventDispatcher;
    
    [ExcludeClass]
    
    /**
     * Oversees and delegates work to a Mockolatier.
     * 
     * Provides a static wrapper around a Mockolatier instance for use with the 
     * <code>mockolate.*</code> package functions. 
     * 
     * Do not reference directly.
     */
    public class MockolatierMaster
    {
    	// create a default Mockolatier
        private static var _mockolatier:Mockolatier = new Mockolatier();
        
        /**
         * Mockolatier instance to use with the <code>mockolate.*</code> 
         * package-level functions. 
         */
        public static function get mockolatier():Mockolatier
        {
            return _mockolatier;
        }
		
		/** @private */
        public static function set mockolatier(value:Mockolatier):void
        {
            if (value)
            {
                _mockolatier = value;
            }
        }
        
        /**
         * @see mockolate#prepare()
         */
        public static function prepare(... rest):IEventDispatcher
        {
            return mockolatier.prepare(rest);
        }
        
        /**
         * @see mockolate#prepare()
         */
        public static function nice(klass:Class, name:String=null, constructorArgs:Array=null):*
        {
            return mockolatier.nice(klass, name, constructorArgs);
        }
        
        /**
         * @see mockolate#strict()
         */
        public static function strict(klass:Class, name:String=null, constructorArgs:Array=null):*
        {
            return mockolatier.strict(klass, name, constructorArgs);
        }
        
        /**
         * @see mockolate#mock()
         */
        public static function mock(target:*):MockingCouverture
        {
            return mockolatier.mock(target);
        }

        /**
         * @see mockolate#stub()
         */
        public static function stub(target:*):MockingCouverture
        {
            return mockolatier.stub(target);
        }
        
        /**
         * @see mockolate#verify()
         */
        public static function verify(target:*):VerifyingCouverture
        {
            return mockolatier.verify(target);
        }
    }
}