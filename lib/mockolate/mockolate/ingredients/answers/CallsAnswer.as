package mockolate.ingredients.answers
{
	import mockolate.ingredients.Invocation;
    
    /**
     * Calls a Function.
     * 
     * @see mockolate.ingredients.MockingCouverture
     * 
     * @example
     * <listing version="3.0">
     *  mock(instance).method("message").calls(function(a:int, b:int):void {
     * 		trace("message", a, b);
     * 		// "message 1 2"
     * 	}, [1, 2]);
     * </listing>
     */
    public class CallsAnswer implements Answer
    {
        private var _function:Function;
        private var _args:Array;
        
        /**
         * Constructor.
         * 
         * @param fn Function to call
         * @param args Array of arguments to pass to fn. 
         */
        public function CallsAnswer(fn:Function, args:Array=null)
        {
            _function = fn;
            _args = args || [];
        }
        
        /**
         * @inheritDoc 
         */
        public function invoke(invocation:Invocation):*
        {
            _function.apply(null, _args);
            return undefined;
        }
    }
}
