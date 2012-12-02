//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.impl
{

	/**
	 * @private
	 */
	public interface IViewProcessorFactory
	{
		/**
		 * @private
		 */
		function runProcessors(view:Object, type:Class, processorMappings:Array):void;

		/**
		 * @private
		 */
		function runUnprocessors(view:Object, type:Class, processorMappings:Array):void;

		/**
		 * @private
		 */
		function runAllUnprocessors():void;
	}
}
