//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.enhancedLogging
{
	import robotlegs.bender.extensions.enhancedLogging.impl.InjectorListener;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.impl.UID;

	public class InjectorActivityLoggingExtension implements IExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _uid:String = UID.create(InjectorActivityLoggingExtension);

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
