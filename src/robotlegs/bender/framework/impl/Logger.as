//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import flash.utils.getTimer;
	import robotlegs.bender.framework.api.ILogTarget;
	import robotlegs.bender.framework.api.ILogger;

	/**
	 * Default Robotlegs logger
	 *
	 * @private
	 */
	public class Logger implements ILogger
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _source:Object;

		private var _target:ILogTarget;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * Creates a new logger
		 * @param source The log source object
		 * @param target The log target
		 */
		public function Logger(source:Object, target:ILogTarget)
		{
			_source = source;
			_target = target;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function debug(message:*, params:Array = null):void
		{
			_target.log(_source, 32, getTimer(), message, params);
		}

		/**
		 * @inheritDoc
		 */
		public function info(message:*, params:Array = null):void
		{
			_target.log(_source, 16, getTimer(), message, params);
		}

		/**
		 * @inheritDoc
		 */
		public function warn(message:*, params:Array = null):void
		{
			_target.log(_source, 8, getTimer(), message, params);
		}

		/**
		 * @inheritDoc
		 */
		public function error(message:*, params:Array = null):void
		{
			_target.log(_source, 4, getTimer(), message, params);
		}

		/**
		 * @inheritDoc
		 */
		public function fatal(message:*, params:Array = null):void
		{
			_target.log(_source, 2, getTimer(), message, params);
		}
	}
}
