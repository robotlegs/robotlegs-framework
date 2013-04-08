//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.commandCenter.api.ICommandCenter;
	import robotlegs.bender.extensions.commandCenter.api.ICommandExecutor;
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
	import robotlegs.bender.extensions.commandCenter.api.ICommandMappingList;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandConfigurator;
	import robotlegs.bender.extensions.commandCenter.dsl.IOnceCommandConfig;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.ILogger;

	public class CommandCenter implements ICommandCenter
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _logger:ILogger;

		public function set logger(value:ILogger):void
		{
			_logger = value;
		}

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _context:IContext;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function CommandCenter(context:IContext)
		{
			_context = context;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function configureCommand(commandClass:Class):IOnceCommandConfig
		{
			return new OnceCommandConfig(commandClass);
		}

		/**
		 * @inheritDoc
		 */
		public function executeCommand(commandClassOrConfig:*, payload:CommandPayload = null):ICommandMapping
		{
			var executed:ICommandMapping;
			const mapping:ICommandMapping = parseMappingFromClassOrConfig(commandClassOrConfig);
			const callback:Function = function(mapping:ICommandMapping):void {
				executed = mapping;
			}
			const executor:ICommandExecutor = new CommandExecutor(_context.injector.createChildInjector(), callback);
			executor.execute(Vector.<ICommandMapping>([mapping]), payload);
			return executed;
		}

		/**
		 * @inheritDoc
		 */
		public function executeCommands(commandClassesOrConfigs:Array, payload:CommandPayload = null):Vector.<ICommandMapping>
		{
			const numCommands:uint = commandClassesOrConfigs.length;
			const list:Vector.<ICommandMapping> = new Vector.<ICommandMapping>(numCommands); //creates fixed length Vector [!]
			for (var i:int = 0; i < numCommands; i++)
			{
				var mapping:ICommandMapping = parseMappingFromClassOrConfig(commandClassesOrConfigs[i]);
				mapping && (list[i] = mapping); //no pushing, fixed length [!]
			}
			const executed:Vector.<ICommandMapping> = new Vector.<ICommandMapping>();
			const callback:Function = function(mapping:ICommandMapping):void {
				executed.push(mapping);
			}
			const executor:ICommandExecutor = new CommandExecutor(_context.injector.createChildInjector(), callback);
			executor.execute(list, payload);
			return executed;
		}

		/**
		 * @inheritDoc
		 */
		public function detain(command:Object):void
		{
			_context.detain(command);
		}

		/**
		 * @inheritDoc
		 */
		public function release(command:Object):void
		{
			_context.release(command);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function parseMappingFromClassOrConfig(commandClassOrConfig:*):ICommandMapping
		{
			var mapping:ICommandMapping;
			if ('getMapping' in commandClassOrConfig)
			{
				mapping = commandClassOrConfig.getMapping();
			}
			else
			{
				const commandClass:Class = commandClassOrConfig as Class;
				commandClass && (mapping = new CommandMapping(commandClass));
			}
			return mapping;
		}
	}
}
