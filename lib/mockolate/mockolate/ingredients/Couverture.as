package mockolate.ingredients
{
    use namespace mockolate_ingredient;
    
    /**
     * Couverture.
     *
     * @see RecordingCouverture
     * @see MockingCouverture
     * 
     * @author drewbourne
     */
    public class Couverture
    {
        /**
         * Constructor.
         */
        public function Couverture(mockolate:Mockolate)
        {
            super();
            
            if (!mockolate)
                throw new ArgumentError("Couverture requires a Mockolate instance.");
            
            _mockolate = mockolate;
        }
        
        /**
         * Mockolate instance this Couverture belongs to.
         */
        public function get mockolate():Mockolate
        {
            return _mockolate;
        }
        
        private var _mockolate:Mockolate;
        
        /**
         * Called by the Mockolate when an Invocation is received.
         *
         * Subclasses should override invoked and perform whatever logic they require.
         */
        mockolate_ingredient function invoked(invocation:Invocation):void
        {
            // abstract
        }
        
        /**
         * Called by Mockolate when verify.
         *
         * Subclasses should override verify and perform whatever logic they require.
         */
        mockolate_ingredient function verify():void
        {
            // abstract
        }
    }
}