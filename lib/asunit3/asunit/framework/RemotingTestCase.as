package asunit.framework 
{
    import flash.errors.IllegalOperationError;
    import flash.events.IOErrorEvent;
    import flash.events.NetStatusEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.NetConnection;
    import flash.net.ObjectEncoding;
    import flash.net.Responder;
    
    import asunit.framework.TestCase;
    import asunit.util.ArrayIterator;    

    /**
     * RemotingTestCase 
     * @author     Jens Krause [www.websector.de]
     * @date     11/29/07
     * 
     */
    public class RemotingTestCase extends TestCase 
    {

        protected var connection: NetConnection;
        /**
        * Constructor
        * @param testMethod        String        Name of the test case
        * 
        */            
        public function RemotingTestCase(testMethod: String = null)
        {
            super(testMethod);
        }

        /**
        * Inits a netConnection instance and add all necessary event listeners
        * 
        */    
        protected function initConnection():void 
        {
            if (connection == null)
            {
                connection = new NetConnection();
                
                connection.addEventListener(NetStatusEvent.NET_STATUS, connectionStatusHandler);
                connection.addEventListener(IOErrorEvent.IO_ERROR, connectionIOErrorHandler);
                connection.addEventListener(SecurityErrorEvent.SECURITY_ERROR , connectionSecurityErrorHandler);        
            }
        }

        /**
        * Dispose the netConnection instance
        * 
        */                    
        protected function disposeConnection():void 
        {
            if (connection != null)
            {
                connection.removeEventListener(NetStatusEvent.NET_STATUS, connectionStatusHandler);
                connection.removeEventListener(IOErrorEvent.IO_ERROR, connectionIOErrorHandler);
                connection.removeEventListener(SecurityErrorEvent.SECURITY_ERROR , connectionSecurityErrorHandler);    
                
                connection = null;            
            }
        }

        /**
        * Callback handler for receiving SecurityErrorEvent
        * @param event        SecurityErrorEvent
        * 
        */    
        protected function connectionSecurityErrorHandler(event: SecurityErrorEvent): void
        {
            result.addError(this, new IllegalOperationError(event.toString()));
            isComplete = true;  
        }

        /**
        * Callback handler for receiving IOErrorEvent
        * @param event        IOErrorEvent
        * 
        */    
        protected function connectionIOErrorHandler(event: IOErrorEvent): void
        {
            result.addError(this, new IllegalOperationError(event.toString()));
            isComplete = true;
        }

        /**
        * Callback handler for receiving NetStatusEvent
        * @param event        NetStatusEvent
        * 
        */
        protected function connectionStatusHandler(event: NetStatusEvent): void
        {
            
        }

        /**
        * Connects the gateway
        * 
        * @param $gateway        String        Remote gateway
        * @param $encoding        uint        Object encoding using either AMF0 or AMF3
        * 
        */                                    
        protected function connect ($gateway: String = null, $encoding: uint = 0): void 
        {
            initConnection();
            
               connection.objectEncoding = ($encoding > ObjectEncoding.AMF0) ? $encoding : ObjectEncoding.AMF0;
                          
               try {
                   connection.connect($gateway);
               }
               catch(error: Error)
               {
                   result.addError(this, error);                         
               }
        };
    
        /**
        * Calls a remote service method and test it 
        * 
        * @param $method        String        Remote service
        * @param $responder        Responder    Responder to handle remoting calls
        * @param $arguments        Array        Rest paramaters (optional) 
        * 
        */    
        protected function call ($method: String = null, $responder: Responder = null, ...$arguments): void    
        {
            var hasReferenceError: Boolean = false;
            
            // parameters for calling connection.call();
            // To avoid using the type unsafe ...rest operator I decided to use type safe parameters within RemotingTestCase.call() 
            // and apply these later to connection.call();
            var params: Array = [];
            
            // check remote method 
            if ($method != null) 
            {
                params.push($method);            
            }
            else
            {
                result.addError(this, new ReferenceError("RemotingTestCase.call() has to defined a remote method."));            
                hasReferenceError = true;
            } 
            
            // check responder
            if ($responder != null) 
            {
                params.push($responder);            
            }
            else
            {
                result.addError(this, new ReferenceError("RemotingTestCase.call() has to defined a responder to handling its results."));                
                hasReferenceError = true;            
            }    
            
            // In case of a reference error invoke test running instantly 
            // to show the errors created above and return
            if (hasReferenceError) 
            {
                super.run();
                return;
            }
            
            
            var arrIterator: ArrayIterator = new ArrayIterator($arguments);
            while (arrIterator.hasNext())
            {
                params.push(arrIterator.next());    
            }    
            
            // call remote service
               try {
                connection.call.apply(null, params);                
               }
               catch(error: Error)
               {
                   result.addError(this, error);                         
               }
                           

        };        
    }
}
