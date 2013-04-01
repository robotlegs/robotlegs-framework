//------------------------------------------------------------------------------
//  Copyright (c) 2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.eventCommandMap.impl
{
	import robotlegs.bender.extensions.commandCenter.api.ICommandMappingList;
	import robotlegs.bender.extensions.commandCenter.api.ICommandUnmapper;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandConfigurator;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMapper;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMapping;

	public class EventCommandMapper implements IEventCommandMapper, ICommandUnmapper, IEventCommandConfigurator
	{

		private var _mappings:ICommandMappingList;

		private var _mapping:IEventCommandMapping;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function EventCommandMapper(mappings:ICommandMappingList)
		{
			_mappings = mappings;
		}

		/**
		 * @inheritDoc
		 */
		public function toCommand(commandClass:Class):IEventCommandConfigurator
		{
			_mapping = new EventCommandMapping(commandClass);
			_mappings.addMapping(_mapping);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function fromCommand(commandClass:Class):void
		{
			_mappings.removeMappingFor(commandClass);
		}

		/**
		 * @inheritDoc
		 */
		public function fromAll():void
		{
			_mappings.removeAllMappings();
		}

		/**
		 * @inheritDoc
		 */
		public function once(value:Boolean = true):IEventCommandConfigurator
		{
			_mapping.setFireOnce(value);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function withGuards(... guards):IEventCommandConfigurator
		{
			_mapping.addGuards.apply(null, guards);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function withHooks(... hooks):IEventCommandConfigurator
		{
			_mapping.addHooks.apply(null, hooks);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function withExecuteMethod(name:String):IEventCommandConfigurator
		{
			_mapping.setExecuteMethod(name);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function withPriority(value:int):IEventCommandConfigurator
		{
			_mapping.setPriority(value);
			return this;
		}
	}
}
