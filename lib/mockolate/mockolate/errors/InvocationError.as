package mockolate.errors
{
	import mockolate.ingredients.Invocation;
	import mockolate.ingredients.Mockolate;

	/**
	 * Invocation-related Error
	 */
	public class InvocationError extends MockolateError
	{
		private var _invocation:Invocation;
		
		/**
		 * Constructor.
		 */
		public function InvocationError(message:Object, invocation:Invocation, mockolate:Mockolate, target:Object)
		{
			super(message, mockolate, target);
			
			_invocation = invocation;
		}
		
		public function get invocation():Invocation
		{
			return _invocation;
		}
	}
}