//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl.contextSupport
{
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.impl.safelyCallBack;

	public class CallbackExtension implements IExtension
	{

		/*============================================================================*/
		/* Public Static Properties                                                   */
		/*============================================================================*/

		public static var staticCallback:Function;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _callback:Function;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function CallbackExtension(callback:Function = null)
		{
			_callback = callback || staticCallback;
			staticCallback = null;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function extend(context:IContext):void
		{
			_callback && safelyCallBack(_callback, null, context);
		}
	}
}
