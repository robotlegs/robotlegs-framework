//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.logging
{
	import robotlegs.bender.extensions.logging.impl.InjectorListener;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.impl.UID;

	public class InjectorLoggingExtension implements IExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _uid:String = UID.create(InjectorLoggingExtension);

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function extend(context:IContext):void
		{
			const listener:InjectorListener = new InjectorListener(
				context.injector, context.getLogger(this));
			context.lifecycle.afterDestroying(listener.destroy);
		}

		public function toString():String
		{
			return _uid;
		}
	}
}
