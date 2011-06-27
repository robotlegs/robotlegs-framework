package mockolate.ingredients.answers
{
	import mockolate.ingredients.Invocation;
    
    /**
     * Throws an Error. 
     *
     * @see mockolate.ingredients.MockingCouverture#throws()
     *  
     * @example
     * <listing version="3.0">
     *  mock(instance).method("explode").throws(new ArgumentError("Oh no!"));
     * </listing>
     */
    public class ThrowsAnswer implements Answer
    {
        private var _error:Error;
        
        /**
         * Constructor.
         * 
         * @param error Error instance to throw.
         */
        public function ThrowsAnswer(error:Error)
        {
            _error = error;
        }
        
        /**
         * @inheritDoc 
         */
        public function invoke(invocation:Invocation):*
        {
            throw _error;
        }
    }
}
