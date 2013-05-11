//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.matching
{

	/**
	 * Type matcher interface
	 */
	public interface ITypeMatcher
	{
		/**
		 * Creates a Type Filter for this Type Matcher
		 * @return The Type Filter
		 */
		function createTypeFilter():ITypeFilter;
	}
}
