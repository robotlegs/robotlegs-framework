package mockolate.ingredients.answers
{
	import mockolate.ingredients.Invocation;
	
	/**
     * @example
     * <listing version="3.0">
     *  stub.pass();
     * </listing>
     */
    public class PassThroughAnswer implements Answer
	{
		/**
		 * Constructor.
		 */
		public function PassThroughAnswer()
		{
		}

		/**
		 * @inheritDoc
		 */
		public function invoke(invocation:Invocation):*
		{
			// return invocation.proceed();
			return undefined;
		}
	}
}
