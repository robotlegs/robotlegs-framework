//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.core.impl
{

	// TODO: should be in API
	public class TypeMatcherError extends Error
	{

		public static const EMPTY_MATCHER:String = "An empty matcher will create a filter which matches nothing. You should specify at least one condition for the filter.";

		public function TypeMatcherError(message:String)
		{
			super(message);
		}
	}
}
