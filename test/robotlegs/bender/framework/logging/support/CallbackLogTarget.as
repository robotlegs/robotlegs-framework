//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.logging.support
{
	import robotlegs.bender.framework.logging.api.ILogTarget;

	public class CallbackLogTarget implements ILogTarget
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _callback:Function;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function CallbackLogTarget(callback:Function)
		{
			_callback = callback;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function log(source:Object, level:uint, timestamp:int, message:String, params:Array = null):void
		{
			_callback && _callback({
					source: source,
					level: level,
					timestamp: timestamp,
					message: message,
					params: params});
		}
	}
}
