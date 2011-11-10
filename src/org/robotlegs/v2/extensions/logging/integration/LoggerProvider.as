//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.logging.integration
{
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.ILogger;
	import org.robotlegs.v2.core.impl.Logger;
	import org.swiftsuspenders.Injector;
	import org.swiftsuspenders.dependencyproviders.DependencyProvider;

	public class LoggerProvider implements DependencyProvider
	{
		public function apply(targetType:Class, activeInjector:Injector):Object
		{
			const context:IContext = activeInjector.getInstance(IContext);
			const name:String = context.id + ' ' + targetType;
			const logger:ILogger = new Logger(name, context.logger.target);
			return logger;
		}
	}
}
