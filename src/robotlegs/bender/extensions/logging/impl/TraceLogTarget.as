//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.logging.impl
{
	import robotlegs.bender.core.api.IContext;
	import robotlegs.bender.core.api.IContextLogTarget;
	import robotlegs.bender.extensions.logging.api.IContextLogFormatter;

	public class TraceLogTarget implements IContextLogTarget
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

		private const _formatter:IContextLogFormatter = new TraceLogFormatter();

		public function TraceLogTarget(level:uint = 0)
		{
			_level = level;
		}

		public function log(
			context:IContext,
			source:Object,
			level:uint,
			timestamp:int,
			message:*,
			parameters:Array = null):void
		{
			trace(_formatter.format(context, source, level, timestamp, message, parameters));
		}
	}
}
