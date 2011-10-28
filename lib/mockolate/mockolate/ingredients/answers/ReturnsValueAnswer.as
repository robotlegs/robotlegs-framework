package mockolate.ingredients.answers
{
	import mockolate.ingredients.Invocation;
    
    /**
     * Returns a value. 
     * 
     * @see mockolate.ingredients.Invocation#returnValue
     * @see mockolate.ingredients.MockingCouverture#returns()
     * 
     * @author drewbourne
     */
    public class ReturnsValueAnswer implements Answer
    {
        private var _value:*;
        
        public function ReturnsValueAnswer(value:*)
        {
            _value = value;
        }
        
        public function invoke(invocation:Invocation):*
        {
            return _value;
        }
    }
}