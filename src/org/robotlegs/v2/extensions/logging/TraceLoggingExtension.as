//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.logging
{
	import org.robotlegs.v2.core.api.ContextLogLevel;
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextExtension;
	import org.robotlegs.v2.extensions.logging.impl.TraceLogTarget;
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
