//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.api
{

	/**
	 * View Processor Map Error
	 */
	public class ViewProcessorMapError extends Error
	{

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * Creates a View Processor Map Error
		 * @param message The error message
		 */
		public function ViewProcessorMapError(message:String)
		{
			super(message);
		}
	}

}

