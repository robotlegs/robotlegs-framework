package mockolate.ingredients.answers
{
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    import flash.utils.setTimeout;
    
    import mockolate.ingredients.Invocation;
    
    /**
     * Dispatches an Event with an optional delay. 
     * 
     * @example
     * <listing version="3.0">
     *  mock(instance).method("update").dispatches(new Event("now"));
     *  mock(instance).method("update").dispatches(new Event("eventually"), 100);
     * </listing>
     */
    public class DispatchesEventAnswer implements Answer
    {
        private var _dispatcher:IEventDispatcher;
        private var _event:Event;
        private var _delay:Number;
        private var _timeout:uint;
        
        /**
         * Constructor. 
         */
        public function DispatchesEventAnswer(dispatcher:IEventDispatcher, event:Event, delay:Number=0)
        {
            _dispatcher = dispatcher;
            _event = event;
            _delay = delay;
        }
        
        /**
         * @inheritDoc 
         */
        public function invoke(invocation:Invocation):*
        {
            if (_delay == 0)
            {
                dispatchEvent();
            }
            else
            {
                _timeout = setTimeout(dispatchEvent, _delay);
            }
            
            return undefined;
        }
        
        /**
         * @private 
         */
        protected function dispatchEvent():void
        {
            _dispatcher.dispatchEvent(_event);
        }
    }
}
