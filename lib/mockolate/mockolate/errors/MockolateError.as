package mockolate.errors 
{
	import asx.string.substitute;
	
	import mockolate.ingredients.Mockolate;
	
	/**
	 * Mockolate-related Error
	 */
	public class MockolateError extends Error 
	{
		private var _mockolate:Mockolate;
		private var _target:Object;
		
		/**
		 * Constructor.
		 */
		public function MockolateError(message:Object, mockolate:Mockolate, target:Object) {
			
			if (message is Array)
				message = substitute(message[0], message[1] || []);
				
			super(message);
			
			_mockolate = mockolate;
			_target = target;
		}
		
		public function get mockolate():Mockolate {
			return _mockolate;
		}
		
		public function get target():Object {
			return _target;
		}
	}
}
