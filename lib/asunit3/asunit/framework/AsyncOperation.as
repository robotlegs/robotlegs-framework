package asunit.framework {
	import asunit.errors.AssertionFailedError;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class AsyncOperation{

		private var timeout:Timer;
		private var testCase:TestCase;
		private var callback:Function;
		private var duration:Number;
		private var failureHandler:Function;

		public function AsyncOperation(testCase:TestCase, handler:Function, duration:Number, failureHandler:Function=null){
			this.testCase = testCase;
			this.duration = duration;
			timeout = new Timer(duration, 1);
			timeout.addEventListener(TimerEvent.TIMER_COMPLETE, onTimeoutComplete);
			timeout.start();
			if(handler == null) {
				handler = function(args:*):* {return;};
			}
			this.failureHandler = failureHandler;
			var context:AsyncOperation = this;
			callback = function(args:*):* {
				timeout.stop();
				try {
					handler.apply(testCase, arguments);
				}
				catch(e:AssertionFailedError) {
					testCase.getResult().addFailure(testCase, e);
				}
				catch(ioe:IllegalOperationError) {
					testCase.getResult().addError(testCase, ioe);
				}
				catch(unknownError:Error) {
					testCase.getResult().addError(testCase, unknownError);
				}
				finally {
					testCase.asyncOperationComplete(context);
				}
				return;
			};
		}
		
		public function getCallback():Function{
			return callback;
		}

		private function onTimeoutComplete(event:TimerEvent):void {
			if(null != failureHandler) {
				failureHandler(new Event('async timeout'));
			}
			testCase.asyncOperationTimeout(this, duration, null==failureHandler);
		}
	}
	
}
