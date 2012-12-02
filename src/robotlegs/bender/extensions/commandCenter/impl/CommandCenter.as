//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{
	import flash.utils.Dictionary;
	import robotlegs.bender.extensions.commandCenter.api.ICommandCenter;
	import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;
	import robotlegs.bender.framework.api.ILogger;

	/**
	 * @private
	 */
	public class CommandCenter implements ICommandCenter
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _logger:ILogger;

		/**
		 * @private
		 */
		public function set logger(value:ILogger):void
		{
			_logger = value;
		}

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _mappers:Dictionary = new Dictionary();

		private const NULL_UNMAPPER:ICommandUnmapper = new NullCommandUnmapper();

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function map(trigger:ICommandTrigger):ICommandMapper
		{
			return _mappers[trigger]
				|| (_mappers[trigger] = new CommandMapper(trigger, _logger));
		}

		/**
		 * @inheritDoc
		 */
		public function unmap(trigger:ICommandTrigger):ICommandUnmapper
		{
			return _mappers[trigger] || NULL_UNMAPPER;
		}
	}
}
