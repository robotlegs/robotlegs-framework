package mockolate.ingredients
{
    use namespace mockolate_ingredient;
    
    /**
     * Couverture that records every Invocation passed to <code>invoked(Invocation)</code>.
     *
     * @author drewbourne
     */
    public class RecordingCouverture extends Couverture
    {
        [ArrayElementType("mockolate.ingredients.Invocation")]
        private var _invocations:Array;
        
        /**
         * Constructor.
         */
        public function RecordingCouverture(mockolate:Mockolate)
        {
            super(mockolate);
            
            _invocations = [];
        }
        
        [ArrayElementType("mockolate.ingredients.Invocation")]
        /**
         * Returns the recorded Invocations up to the time this property is accessed.
         */
        mockolate_ingredient function get invocations():Array
        {
            return _invocations.slice(0);
        }
        
        /**
         * Records the given Invocation.
         */
        override mockolate_ingredient function invoked(invocation:Invocation):void
        {
            addInvocation(invocation);
        }
        
        /**
         * Adds an Invocation to the <code>invocations</code> Array.
         */
        protected function addInvocation(invocation:Invocation):void
        {
            _invocations.push(invocation);
        }
        
        /**
         * @private
         */
        override mockolate_ingredient function verify():void
        {
        
        }
    }
}
