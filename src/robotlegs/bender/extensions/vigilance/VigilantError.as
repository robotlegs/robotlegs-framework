//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.vigilance
{

	/**
	 * Vigilant Error
	 */
	public class VigilantError extends Error
	{

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * Creates a Vigilant Error
		 * @param message The error message
		 */
		public function VigilantError(message:String)
		{
			super(message);
		}
	}
}
