//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{
	/**
	 * @author creynder
	 */
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandConfigurator;
	import robotlegs.bender.extensions.commandCenter.dsl.IOnceCommandConfig;

	public class OnceCommandConfig implements IOnceCommandConfig
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _mapping:ICommandMapping;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function OnceCommandConfig(commandClass:Class)
		{
			_mapping = new CommandMapping(commandClass);
			_mapping.setFireOnce(true);
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function getMapping():ICommandMapping
		{
			return _mapping;
		}

		/**
		 * @inheritDoc
		 */
		public function withExecuteMethod(name:String):IOnceCommandConfig
		{
			_mapping.setExecuteMethod(name);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function withGuards(... guards):IOnceCommandConfig
		{
			_mapping.addGuards.apply(null, guards);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function withHooks(... hooks):IOnceCommandConfig
		{
			_mapping.addHooks.apply(null, hooks);
			return this;
		}

		/**
		 * @inheritDoc
		 */
		public function withPayloadInjection(value:Boolean=true):IOnceCommandConfig
		{
			_mapping.setPayloadInjectionEnabled(value);
			return this;
		}

	}
}
