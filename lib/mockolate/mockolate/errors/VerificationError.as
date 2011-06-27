package mockolate.errors
{
	import mockolate.ingredients.Expectation;
	import mockolate.ingredients.Mockolate;
	import mockolate.ingredients.Verification;

	/**
	 * Verification-related Error
	 */
	public class VerificationError extends MockolateError
	{
		private var _verification:Verification;
		
		/**
		 * Constructor.
		 */
		public function VerificationError(
			message:Object, 
			verification:Verification,
			mockolate:Mockolate, 
			target:Object)
		{
			super(message, mockolate, target);
			
			_verification = verification;
		}
		
		/**
		 * Verification instance related to this Error
		 */
		public function get verification():Verification
		{
			return _verification;
		}
	}
}