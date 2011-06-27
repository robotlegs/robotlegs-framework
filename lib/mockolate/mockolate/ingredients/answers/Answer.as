package mockolate.ingredients.answers
{
	import mockolate.ingredients.Invocation;
	
    /**
     * Answer instances are used by <code>mock()</code> and <code>stub()</code>
     * to define the behaviour of a method or property invocation. 
     * 
     * @author drewbourne
     */
    public interface Answer
    {
    	/**
    	 * Perform Answer action. 
    	 * 
    	 * @param invocation
    	 * @returns possible Invocation.returnValue
    	 */
        function invoke(invocation:Invocation):*;
    }
}
