//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.core.impl.support
{
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextLogTarget;

	public class CallbackLogTarget implements IContextLogTarget
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

		public function log(context:IContext, source:Object, level:uint, timestamp:int, message:*, parameters:Array = null):void
		{
			callback(context, source, level, timestamp, message, parameters);
		}
	}
}
