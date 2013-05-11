//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.matching
{
	import robotlegs.bender.framework.api.IMatcher;

	/**
	 * A Type Filter describes a Type Matcher
	 */
	public interface ITypeFilter extends IMatcher
	{
		/**
		 * All types that an item must extend or implement
		 */
		function get allOfTypes():Vector.<Class>;

		/**
		 * Any types that an item must extend or implement
		 */
		function get anyOfTypes():Vector.<Class>;

		/**
		 * Types that an item must not extend or implement
		 */
		function get noneOfTypes():Vector.<Class>;

		/**
		 * Unique description for this filter
		 */
		function get descriptor():String;
	}
}
