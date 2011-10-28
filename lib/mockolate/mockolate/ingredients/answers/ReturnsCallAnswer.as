package mockolate.ingredients.answers
{
	import mockolate.ingredients.Invocation;
    
    /**
     * Calls a Function and returns the resulting value. 
     * 
     * @see ReturnsAnswer
     * @see mockolate.ingredients.Invocation#returnValue
     * @see mockolate.ingredients.MockingCouverture#returns()
     * 
     * @author drewbourne 
     */
    public class ReturnsCallAnswer implements Answer
    {
        private var _function:Function;
        private var _args:Array;
        
        /**
         * Constructor. 
         */
        public function ReturnsCallAnswer(fn:Function, args:Array=null)
        {
            _function = fn;
            _args = args || [];
        }
        
        /**
         * @inheritDoc 
         */
        public function invoke(invocation:Invocation):*
        {
            return _function.apply(null, _args);
        }
    }
}
