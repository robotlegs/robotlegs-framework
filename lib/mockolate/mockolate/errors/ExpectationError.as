package mockolate.errors
{
	import mockolate.ingredients.Expectation;
	import mockolate.ingredients.Mockolate;

	/**
	 * Expectation-related Error 
	 */
	public class ExpectationError extends MockolateError
	{
		private var _expectation:Expectation;
		
		/**
		 * Constructor
		 */
		public function ExpectationError(message:Object, expectation:Expectation, mockolate:Mockolate, target:Object)
		{
			super(message, mockolate, target);
			
			_expectation = expectation;
		}
		
		/**
		 * Expectation instance related to this Error
		 */
		public function get expectation():Expectation
		{
			return _expectation;
		}
	}
}