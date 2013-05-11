//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.dsl
{

	/**
	 * Unmaps a view processor
	 */
	public interface IViewProcessorUnmapper
	{
		/**
		 * Unmaps a processor from a matcher
		 * @param processorClassOrInstance
		 */
		function fromProcess(processorClassOrInstance:*):void;

		/**
		 * Unmaps a matcher
		 */
		function fromNoProcess():void;

		/**
		 * Unmaps an injection processor
		 */
		function fromInjection():void;

		/**
		 * Unmaps all processors from this matcher
		 */
		function fromAll():void;
	}

}
