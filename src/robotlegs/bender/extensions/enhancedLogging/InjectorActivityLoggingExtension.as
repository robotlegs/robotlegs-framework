//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.enhancedLogging
{
	import robotlegs.bender.extensions.enhancedLogging.impl.InjectorListener;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;

	/**
	 * This extension logs messages for all Injector actions.
	 *
	 * Warning: this extension will degrade the performance of your application.
	 */
	public class InjectorActivityLoggingExtension implements IExtension
	{

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function extend(context:IContext):void
		{
			const listener:InjectorListener = new InjectorListener(
				context.injector, context.getLogger(this));
			context.afterDestroying(listener.destroy);
		}
	}
}
