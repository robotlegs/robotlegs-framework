package mockolate.ingredients.faux
{
    import mockolate.ingredients.Invocation;
    import mockolate.ingredients.Mockolate;
    import mockolate.ingredients.mockolate_ingredient;
    
    import org.floxy.IInterceptor;
    import org.floxy.IInvocation;
    
    use namespace mockolate_ingredient;
    
    public class FauxFloxyInterceptor implements IInterceptor
    {
        private var _interceptHandler:Function;
        
        public function FauxFloxyInterceptor(interceptorHandler:Function)
        {
            super();
            
            _interceptHandler = interceptorHandler;
        }
        
        public function intercept(invocation:IInvocation):void
        {
            _interceptHandler(invocation);
        }
    }
}