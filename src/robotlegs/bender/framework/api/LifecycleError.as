//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.api
{

	/**
	 * Lifecycle Error
	 */
	public class LifecycleError extends Error
	{

		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/

		public static const SYNC_HANDLER_ARG_MISMATCH:String = "When and After handlers must accept 0 or 1 arguments";

		public static const LATE_HANDLER_ERROR_MESSAGE:String = "Handler added late and will never fire";

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * Creates a Lifecycle Error
		 * @param message The error message
		 */
		public function LifecycleError(message:String)
		{
			super(message);
		}
	}
}
