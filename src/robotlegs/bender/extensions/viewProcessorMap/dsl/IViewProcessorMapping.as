//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.dsl
{
	import robotlegs.bender.extensions.matching.ITypeFilter;

	/**
	 * View Processor Mapping
	 */
	public interface IViewProcessorMapping
	{
		/**
		 * The matcher for this mapping
		 */
		function get matcher():ITypeFilter;

		/**
		 * The processor for this mapping
		 */
		function get processor():Object;

		/**
		 * Sets the processor for this mapping
		 */
		function set processor(value:Object):void;

		/**
		 * The processor class for this mapping
		 */
		function get processorClass():Class;

		/**
		 * A list of guards to consult before allowing a view to be processed
		 */
		function get guards():Array;

		/**
		 * A list of hooks to run before processing a view
		 */
		function get hooks():Array;
	}
}
