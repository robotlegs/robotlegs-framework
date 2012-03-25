//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.context.support
{
	import robotlegs.bender.core.async.safelyCallBack;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.context.api.IContextExtension;

	public class CallbackExtension implements IContextExtension
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
