package mockolate.ingredients
{
    import flash.events.IEventDispatcher;
    
    /**
     * Factory interface to prepare and create Mockolate instances.
     * 
     * @author drewbourne
     */
    public interface MockolateFactory
    {
        /**
         * Prepares the given Class references for use with the Mockolate library.
         * 
         * @param ...rest Class references to prepare proxies for.
         * @returns IEventDispatcher to listen for <code>Event.COMPLETE</code> 
         */
        function prepare(... rest):IEventDispatcher;
        
        /**
         * Create an instance of Mockolate for the given Class reference.
         * 
         * Attempting to call <code>create()</code> before <code>prepare()</code> 
         * has completed for that class will throw an Error.  
         * 
         * @param klass Class reference that has been given to <code>prepare()</code>.
         * @param constructorArgs Array of args to pass to the target instances constructor.
         * @param asStrict Indicates if the Mockolate should be create in strict mode.
         * @param name Name of the Mockolate instance to aid with debugging. 
         * @returns Mockolate instance.
         * 
         * @see Mockolate#isStrict
         */
        function create(klass:Class, constructorArgs:Array=null, asStrict:Boolean=true, name:String=null):Mockolate;
    }
}