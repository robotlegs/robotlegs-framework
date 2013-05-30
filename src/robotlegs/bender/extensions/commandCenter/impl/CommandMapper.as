//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
	import robotlegs.bender.extensions.commandCenter.api.ICommandMappingList;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandConfigurator;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;

	/**
	 * @private
	 */
	public class CommandMapper implements ICommandMapper, ICommandUnmapper, ICommandConfigurator
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _mappings:ICommandMappingList;

		private var _mapping:ICommandMapping;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * Creates a Command Mapper
		 * @param mappings The command mapping list to add mappings to
		 */
		public function CommandMapper(mappings:ICommandMappingList)
		{
			_mappings = mappings;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function toCommand(commandClass:Class):ICommandConfigurator
		{
			_mapping = new CommandMapping(commandClass);
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
		public function once(value:Boolean = true):ICommandConfigurator
		{
			_mapping.setFireOnce(value);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function withGuards(... guards):ICommandConfigurator
		{
			_mapping.addGuards.apply(null, guards);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function withHooks(... hooks):ICommandConfigurator
		{
			_mapping.addHooks.apply(null, hooks);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function withExecuteMethod(name:String):ICommandConfigurator
		{
			_mapping.setExecuteMethod(name);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function withPayloadInjection(value:Boolean = true):ICommandConfigurator
		{
			_mapping.setPayloadInjectionEnabled(value);
			return this;
		}
	}
}
