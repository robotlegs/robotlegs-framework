//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.core.impl
{
	import org.robotlegs.v2.core.api.ILogTarget;
	import org.robotlegs.v2.core.api.ILogger;

	/**
	 * Code duplication and magic numbers, but we want the speed
	 */
	public class Logger implements ILogger
	{

		private var _target:ILogTarget;

		public function get target():ILogTarget
		{
			return _target;
		}

		public function set target(value:ILogTarget):void
		{
			_target = value;
		}

		private var _name:String;

		public function Logger(name:String, target:ILogTarget = null)
		{
			_name = name;
			_target = target;
		}

		public function debug(message:*, parameters:Array = null):void
		{
			_target && _target.level >= 32 && _target.log(_name, 32, new Date().time, message, parameters);
		}

		public function info(message:*, parameters:Array = null):void
		{
			_target && _target.level >= 16 && _target.log(_name, 16, new Date().time, message, parameters);
		}

		public function warn(message:*, parameters:Array = null):void
		{
			_target && _target.level >= 8 && _target.log(_name, 8, new Date().time, message, parameters);
		}

		public function error(message:*, parameters:Array = null):void
		{
			_target && _target.level >= 4 && _target.log(_name, 4, new Date().time, message, parameters);
		}

		public function fatal(message:*, parameters:Array = null):void
		{
			_target && _target.level >= 2 && _target.log(_name, 2, new Date().time, message, parameters);
		}
	}
}
