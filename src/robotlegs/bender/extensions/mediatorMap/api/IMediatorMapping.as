//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.api
{
	import robotlegs.bender.extensions.matching.ITypeFilter;

	/**
	 * Represents a Mediator mapping
	 */
	public interface IMediatorMapping
	{
		/**
		 * The matcher for this mapping
		 */
		function get matcher():ITypeFilter;

		/**
		 * The concrete mediator class
		 */
		function get mediatorClass():Class;

		/**
		 * A list of guards to check before allowing mediator creation
		 */
		function get guards():Array;

		/**
		 * A list of hooks to run before creating a mediator
		 */
		function get hooks():Array;

		/**
		 * Should the mediator be removed when the mediated item looses scope?
		 */
		function get autoRemoveEnabled():Boolean;
	}
}
