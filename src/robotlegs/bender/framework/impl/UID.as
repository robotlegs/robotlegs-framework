//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import flash.utils.getQualifiedClassName;

	/**
	 * Utility for generating unique object IDs
	 */
	public class UID
	{

		/*============================================================================*/
		/* Private Static Properties                                                  */
		/*============================================================================*/

		private static var _i:uint;

		/*============================================================================*/
		/* Public Static Functions                                                    */
		/*============================================================================*/

		/**
		 * Generates a UID for a given source object or class
		 * @param source The source object or class
		 * @return Generated UID
		 */
		public static function create(source:* = null):String
		{
			if (source is Class)
				source = getQualifiedClassName(source).split("::").pop();

			return (source ? source + '-' : '')
				+ (_i++).toString(16)
				+ '-'
				+ (Math.random() * 255).toString(16);
		}
	}
}
