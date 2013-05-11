//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.impl
{
	import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorUnmapper;

	/**
	 * @private
	 */
	public class NullViewProcessorUnmapper implements IViewProcessorUnmapper
	{

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function fromProcess(processorClassOrInstance:*):void
		{
		}

		/**
		 * @private
		 */
		public function fromAll():void
		{
		}

		/**
		 * @private
		 */
		public function fromNoProcess():void
		{
		}

		/**
		 * @private
		 */
		public function fromInjection():void
		{
		}
	}
}
