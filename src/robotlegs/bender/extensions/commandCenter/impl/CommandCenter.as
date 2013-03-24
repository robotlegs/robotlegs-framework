//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{
	import flash.utils.Dictionary;
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapper;
	import robotlegs.bender.extensions.commandCenter.api.ICommandMappingList;
	import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
	import robotlegs.bender.extensions.commandCenter.api.ICommandUnmapper;
	import robotlegs.bender.framework.api.ILogger;

	public class CommandCenter
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _mappers:Dictionary = new Dictionary();

		private const _triggers:Dictionary = new Dictionary();

		private var _nullCommandUnmapper:ICommandUnmapper = new NullCommandUnmapper();

		private var _keyFactory:Function;

		private var _triggerFactory:Function;

		private var _mapperFactory:Function;

		private var _logger:ILogger;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function CommandCenter(keyFactory:Function, triggerFactory:Function)
		{
			_keyFactory = keyFactory;
			_triggerFactory = triggerFactory;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function withLogger(logger:ILogger):CommandCenter
		{
			_logger = logger;
			return this;
		}

		public function withMapperFactory(mapperFactory:Function):CommandCenter
		{
			_mapperFactory = mapperFactory;
			return this;
		}

		public function withNullCommandUnmapper(unmapper:ICommandUnmapper):CommandCenter
		{
			_nullCommandUnmapper = unmapper;
			return this;
		}

		public function getMapper(... params):ICommandMapper
		{
			const key:Object = getKey(params);
			return _mappers[key] || buildCommandMapper(key, params);
		}

		public function getUnmapper(... params):ICommandUnmapper
		{
			return _mappers[getKey(params)] || _nullCommandUnmapper;
		}

		public function removeMapper(... params):ICommandMapper
		{
			return destroyMapper(getKey(params));
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function getKey(mapperArgs:Array):Object
		{
			return _keyFactory.apply(null, mapperArgs);
		}

		private function buildCommandMapper(key:Object, mapperArgs:Array):ICommandMapper
		{
			const mappings:ICommandMappingList = new CommandMappingList(_logger);

			const trigger:ICommandTrigger = createTrigger(mapperArgs);
			trigger.executor.mappings = mappings;
			_triggers[key] = trigger;

			const mapper:ICommandMapper = createMapper(mapperArgs);
			mapper.mappings = mappings;
			_mappers[key] = mapper;

			mappings.trigger = trigger;

			return mapper;
		}

		private function createTrigger(mapperArgs:Array):ICommandTrigger
		{
			return _triggerFactory.apply(null, mapperArgs);
		}

		private function createMapper(mapperArgs:Array):ICommandMapper
		{
			return _mapperFactory == null
				? new DefaultCommandMapper()
				: _mapperFactory.apply(null, mapperArgs);
		}

		private function destroyMapper(key:Object):ICommandMapper
		{
			const trigger:ICommandTrigger = _triggers[key];
			const mapper:ICommandMapper = _mappers[key];
			if (trigger)
			{
				trigger.deactivate();
				delete _triggers[key];
				delete _mappers[key];
			}
			return mapper;
		}
	}
}
