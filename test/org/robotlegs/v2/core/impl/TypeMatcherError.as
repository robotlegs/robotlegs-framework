package org.robotlegs.v2.core.impl
{
	public class TypeMatcherError extends Error
	{
		public static const EMPTY_MATCHER:String = "An empty matcher will create a filter which matches nothing. You should specify at least one condition for the filter.";
		
		public function TypeMatcherError(message:String)
		{
			super(message);
		}
	}
}