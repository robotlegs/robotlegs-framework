package mockolate.ingredients.floxy
{
    import flash.events.IEventDispatcher;
    
    import mockolate.ingredients.MockingCouverture;
    import mockolate.ingredients.Mockolate;
    import mockolate.ingredients.MockolateFactory;
    import mockolate.ingredients.RecordingCouverture;
    import mockolate.ingredients.VerifyingCouverture;
    import mockolate.ingredients.mockolate_ingredient;
    
    import org.floxy.IProxyRepository;
    import org.floxy.ProxyRepository;
    
    use namespace mockolate_ingredient;
    
    /**
     * MockolateFactory implementation using FLoxy to generate Class proxies. 
     */
    public class FloxyMockolateFactory implements MockolateFactory
    {
        private var _proxyRespository:IProxyRepository;
        
        /**
         * Constructor. 
         */
        public function FloxyMockolateFactory()
        {
            _proxyRespository = new ProxyRepository();
        }
        
        /**
         * @inheritDoc 
         */
        public function prepare(... rest):IEventDispatcher
        {
            return _proxyRespository.prepare(rest);
        }
        
        /**
         * @inheritDoc 
         */
        public function create(klass:Class, constructorArgs:Array=null, asStrict:Boolean=true, name:String=null):Mockolate
        {
            var mockolate:FloxyMockolate = createMockolate(asStrict, name) as FloxyMockolate;
            var target:* = _proxyRespository.create(klass, constructorArgs || [], mockolate.interceptor);
            mockolate.target = target;
            return mockolate;
        }
        
        /**
         * @private 
         */
        protected function createMockolate(asStrict:Boolean=false, name:String=null):Mockolate
        {
            var mockolate:FloxyMockolate = new FloxyMockolate(name);
            mockolate.isStrict = asStrict;
            
            mockolate.interceptor = createInterceptor(mockolate);
//            mockolate.recorder = createRecorder(mockolate);
//            mockolate.stubber = createStubber(mockolate);
            mockolate.mocker = createMocker(mockolate);
            mockolate.verifier = createVerifier(mockolate);
            
            return mockolate;
        }
        
        /**
         * @private 
         */
        protected function createInterceptor(mockolate:Mockolate):InterceptingCouverture
        {
            return new InterceptingCouverture(mockolate);
        }
        
        /**
         * @private 
         */
        protected function createRecorder(mockolate:Mockolate):RecordingCouverture
        {
            return new RecordingCouverture(mockolate);
        }
        
        /**
         * @private 
         */
        protected function createMocker(mockolate:Mockolate):MockingCouverture
        {
            return new MockingCouverture(mockolate);
        }

        /**
         * @private 
         */
        protected function createVerifier(mockolate:Mockolate):VerifyingCouverture
        {
            return new VerifyingCouverture(mockolate);
        }
    }
}