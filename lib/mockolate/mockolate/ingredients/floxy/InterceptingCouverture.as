package mockolate.ingredients.floxy
{
    import org.floxy.IInterceptor;
    import org.floxy.IInvocation;
    
    import asx.string.substitute;
    
    import mockolate.ingredients.Couverture;
    import mockolate.ingredients.Invocation;
    import mockolate.ingredients.Mockolate;
    import mockolate.ingredients.mockolate_ingredient;
    
    use namespace mockolate_ingredient;
    
    /**
     * FLoxy IInterceptor implementation for Mockolate. 
     */
    public class InterceptingCouverture extends Couverture implements IInterceptor
    {
    	/**
    	 * Constructor.
    	 */
        public function InterceptingCouverture(mockolate:Mockolate)
        {
            super(mockolate);
        }
        
        /**
         * Called by FLoxy proxy instances.
         * 
         * @private  
         */
        public function intercept(invocation:IInvocation):void
        {
            mockolate.mockolate_ingredient::invoked(new FloxyInvocation(invocation));
        }
    }
}
