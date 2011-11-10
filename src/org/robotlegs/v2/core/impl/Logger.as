//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.core.impl
{
	import org.robotlegs.v2.core.api.ILogger;
	import org.robotlegs.v2.core.api.ILoggingTarget;

	public class Logger implements ILogger
	{
		private var target:ILoggingTarget;

		private var name:String;

		public function Logger(target:ILoggingTarget, name:String)
		{
			this.target = target;
			this.name = name;
		}

		public function debug(message:*, parameters:Array = null):void
		{
			target.level >= 32 && target.log(name, 32, message, parameters);
		}

		public function info(message:*, parameters:Array = null):void
		{
			target.level >= 16 && target.log(name, 16, message, parameters);
		}

		public function warn(message:*, parameters:Array = null):void
		{
			target.level >= 8 && target.log(name, 8, message, parameters);
		}

		public function error(message:*, parameters:Array = null):void
		{
			target.level >= 4 && target.log(name, 4, message, parameters);
		}

		public function fatal(message:*, parameters:Array = null):void
		{
			target.level >= 2 && target.log(name, 2, message, parameters);
		}
	}
}
