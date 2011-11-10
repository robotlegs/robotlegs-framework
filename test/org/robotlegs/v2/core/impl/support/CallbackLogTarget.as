//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.core.impl.support
{
	import org.robotlegs.v2.core.api.ILogTarget;

	public class CallbackLogTarget implements ILogTarget
	{
		private var _level:uint;

		public function get level():uint
		{
			return _level;
		}

		public function set level(value:uint):void
		{
			_level = value;
		}

		private var callback:Function;

		public function CallbackLogTarget(level:uint, callback:Function)
		{
			_level = level;
			this.callback = callback;
		}

		public function log(name:String, level:uint, time:Number, message:*, parameters:Array = null):void
		{
			callback(name, level, time, message, parameters);
		}
	}
}
