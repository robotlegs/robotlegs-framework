package mockolate.ingredients.floxy
{
    import mockolate.ingredients.Mockolate;
    import mockolate.ingredients.mockolate_ingredient;
    
    use namespace mockolate_ingredient;
    
    /**
     * Mockolate extension for use with FLoxy proxies.
     */
    public class FloxyMockolate extends Mockolate
    {
        // couvertures 
        private var _interceptor:InterceptingCouverture;
        
        public function FloxyMockolate(name:String)
        {
            super(name);
        }
        
        /**
         * FLoxy IInterceptor.
         */
        mockolate_ingredient function get interceptor():InterceptingCouverture
        {
            return _interceptor;
        }
        
        mockolate_ingredient function set interceptor(value:InterceptingCouverture):void
        {
            _interceptor = value;
        }
    }
}