//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.enhancedLogging.support
{
	import robotlegs.bender.framework.api.ILogTarget;

	public class SupportLogTarget implements ILogTarget
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _callback:Function;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function SupportLogTarget(callback:Function)
		{
			_callback = callback;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function log(source:Object, level:uint, timestamp:int, message:String, params:Array = null):void
		{
			_callback(params);
		}
	}
}
