//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import robotlegs.bender.framework.api.ILogTarget;
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.bender.framework.api.LogLevel;

	/**
	 * The log manager creates loggers and is itself a log target
	 *
	 * @private
	 */
	public class LogManager implements ILogTarget
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _logLevel:uint = LogLevel.INFO;

		/**
		 * The current log level
		 */
		public function get logLevel():uint
		{
			return _logLevel;
		}

		/**
		 * Sets the current log level
		 */
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

		/**
		 * Retrieves a logger for a given source
		 * @param source Logging source
		 * @return Logger
		 */
		public function getLogger(source:Object):ILogger
		{
			return new Logger(source, this);
		}

		/**
		 * Adds a custom log target
		 * @param target Log target
		 * @return this
		 */
		public function addLogTarget(target:ILogTarget):void
		{
			_targets.push(target);
		}

		/**
		 * @inheritDoc
		 */
		public function log(
			source:Object,
			level:uint,
			timestamp:int,
			message:String,
			params:Array = null):void
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
