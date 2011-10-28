package mockolate.ingredients.faux
{
    import mockolate.ingredients.Invocation;
    import mockolate.ingredients.Mockolate;
    import mockolate.ingredients.mockolate_ingredient;
    
    import org.floxy.IInterceptor;
    import org.floxy.IInvocation;
    
    use namespace mockolate_ingredient;
    
    public class FauxMockolate extends Mockolate
    {
        private var _invokedHandler:Function;
        
        public function FauxMockolate(invokedHandler:Function, name:String=null)
        {
            super(name);
            
            _invokedHandler = invokedHandler;
        }
        
        override mockolate_ingredient function invoked(invocation:Invocation):Mockolate
        {
            _invokedHandler(invocation);
            return this;
        }
    }
}
