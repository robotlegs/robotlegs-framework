//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.logging
{
	import robotlegs.bender.extensions.logging.impl.InjectorListener;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.context.api.IContextExtension;

	public class InjectorLoggingExtension implements IContextExtension
	{

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function extend(context:IContext):void
		{
			const listener:InjectorListener = new InjectorListener(context.injector, context.getLogger(this));
			context.lifecycle.afterDestroying(listener.destroy);
		}
	}
}
