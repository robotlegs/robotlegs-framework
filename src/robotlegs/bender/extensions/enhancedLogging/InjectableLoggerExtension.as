//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.enhancedLogging
{
	import robotlegs.bender.extensions.enhancedLogging.integration.LoggerProvider;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.bender.framework.impl.UID;

	public class InjectableLoggerExtension implements IExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _uid:String = UID.create(InjectableLoggerExtension);

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function extend(context:IContext):void
		{
			context.injector.map(ILogger).toProvider(new LoggerProvider(context));
		}

		public function toString():String
		{
			return _uid;
		}
	}
}
