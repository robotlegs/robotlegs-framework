//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.logging.impl
{
	import org.robotlegs.v2.core.api.LogLevel;
	import org.robotlegs.v2.extensions.logging.api.ILogFormatter;

	public class TraceLogFormatter implements ILogFormatter
	{
		public function format(name:String, level:uint, time:Number, message:*, parameters:Array = null):String
		{
			return time
				+ ' ' + LogLevel.getName(level)
				+ ' - ' + name
				+ ' - ' + message
				+ (parameters ? ' - ' + parameters : '');
		}
	}
}
