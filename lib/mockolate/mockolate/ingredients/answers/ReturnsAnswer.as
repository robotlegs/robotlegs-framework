package mockolate.ingredients.answers
{
    import asx.number.bound;
    
    import mockolate.ingredients.Invocation;
    
    /**
     * Returns values for possible assignment to Invocation.returnValue. 
     *
     * @see ReturnsCallAnswer
     * @see ReturnsValueAnswer
     * @see mockolate.ingredients.Invocation#returnValue
     * @see mockolate.ingredients.MockingCouverture#returns()
     *  
     * @example
     * <listing version="3.0">
     *  mock(instance).method("toString").returns("[Instance]");
     * </listing>
     * 
     * @author drewbourne
     */
    public class ReturnsAnswer implements Answer
    {
        private var _values:Array;
        private var _index:int;
        
        /**
         * Constructor. 
         */
        public function ReturnsAnswer(values:Array)
        {
            _values = values || [];
            _index = -1;
        }
        
        /**
         * @inheritDoc 
         */
        public function invoke(invocation:Invocation):*
        {
            _index++;
            _index = bound(_index, 0, _values.length - 1);
            
            var value:* = _values[_index];
            return (value is Answer) 
            	? (value as Answer).invoke(invocation) 
            	: value;
        }
    }
}