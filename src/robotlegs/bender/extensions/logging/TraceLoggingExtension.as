//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.logging
{
	import robotlegs.bender.core.api.ContextLogLevel;
	import robotlegs.bender.core.api.IContext;
	import robotlegs.bender.core.api.IContextExtension;
	import robotlegs.bender.extensions.logging.impl.TraceLogTarget;
	import org.swiftsuspenders.Injector;

	public class TraceLoggingExtension implements IContextExtension
	{
		private var context:IContext;

		private var injector:Injector;

		public function install(context:IContext):void
		{
			this.context = context;
			context.logger.addTarget(new TraceLogTarget(ContextLogLevel.DEBUG));
		}

		public function initialize():void
		{
		}

		public function uninstall():void
		{
		}
	}
}
