//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.logging.impl
{
	import robotlegs.bender.framework.logging.api.ILogManager;
	import robotlegs.bender.framework.logging.api.ILogTarget;
	import robotlegs.bender.framework.logging.api.ILogger;
	import robotlegs.bender.framework.logging.api.LogLevel;

	public class LogManager implements ILogManager, ILogTarget
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _logLevel:uint = LogLevel.INFO;

		public function get logLevel():uint
		{
			return _logLevel;
		}

		public function set logLevel(value:uint):void
		{
			_logLevel = value;
		}

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _targets:Vector.<ILogTarget> = new Vector.<ILogTarget>;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function getLogger(source:Object):ILogger
		{
			return new Logger(source, this);
		}

		public function addLogTarget(target:ILogTarget):void
		{
			_targets.push(target);
		}

		public function log(source:Object, level:uint, timestamp:int, message:String, params:Array = null):void
		{
			if (level > _logLevel)
				return;

			for each (var target:ILogTarget in _targets)
			{
				target.log(source, level, timestamp, message, params);
			}
		}
	}
}
