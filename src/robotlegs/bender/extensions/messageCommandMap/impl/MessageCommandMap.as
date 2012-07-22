//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.messageCommandMap.impl
{
	import flash.utils.Dictionary;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.framework.api.IMessageDispatcher;
	import robotlegs.bender.extensions.commandCenter.api.ICommandCenter;
	import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMappingFinder;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;
	import robotlegs.bender.extensions.messageCommandMap.api.IMessageCommandMap;

	public class MessageCommandMap implements IMessageCommandMap
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _triggers:Dictionary = new Dictionary();

		private var _injector:Injector;

		private var _dispatcher:IMessageDispatcher;

		private var _commandCenter:ICommandCenter;
		
		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function MessageCommandMap(
			injector:Injector,
			dispatcher:IMessageDispatcher,
			commandCenter:ICommandCenter)
		{
			_injector = injector;
			_dispatcher = dispatcher;
			_commandCenter = commandCenter;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function map(message:Object):ICommandMapper
		{
			const trigger:ICommandTrigger =
				_triggers[message] ||=
				createTrigger(message);
			return _commandCenter.map(trigger);
		}

		public function unmap(message:Object):ICommandUnmapper
		{
			return _commandCenter.unmap(getTrigger(message));
		}

		public function getMapping(message:Object):ICommandMappingFinder
		{
			return _commandCenter.getMapping(getTrigger(message));
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function createTrigger(message:Object):ICommandTrigger
		{
			return new MessageCommandTrigger(_injector, _dispatcher, message);
		}

		private function getTrigger(message:Object):ICommandTrigger
		{
			return _triggers[message];
		}
	}
}
