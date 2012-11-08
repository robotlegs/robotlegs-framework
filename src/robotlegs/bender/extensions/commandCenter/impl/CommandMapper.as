//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{
	import flash.utils.Dictionary;
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
	import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMappingConfig;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;
	import robotlegs.bender.framework.api.ILogger;

	public class CommandMapper implements ICommandMapper, ICommandUnmapper
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _mappings:Dictionary = new Dictionary();

		private var _trigger:ICommandTrigger;

		private var _logger:ILogger;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function CommandMapper(trigger:ICommandTrigger, logger:ILogger = null)
		{
			_trigger = trigger;
			_logger = logger;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function toCommand(commandClass:Class):ICommandMappingConfig
		{
			const mapping:ICommandMapping = _mappings[commandClass];
			return mapping
				? overwriteMapping(mapping)
				: createMapping(commandClass);
		}

		public function fromCommand(commandClass:Class):void
		{
			const mapping:ICommandMapping = _mappings[commandClass];
			mapping && deleteMapping(mapping);
		}

		public function fromAll():void
		{
			for each (var mapping:ICommandMapping in _mappings)
			{
				deleteMapping(mapping);
			}
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function createMapping(commandClass:Class):CommandMapping
		{
			const mapping:CommandMapping = new CommandMapping(commandClass);
			_trigger.addMapping(mapping);
			_mappings[commandClass] = mapping;
			_logger && _logger.debug('{0} mapped to {1}', [_trigger, mapping]);
			return mapping;
		}

		private function deleteMapping(mapping:ICommandMapping):void
		{
			_trigger.removeMapping(mapping);
			delete _mappings[mapping.commandClass];
			_logger && _logger.debug('{0} unmapped from {1}', [_trigger, mapping]);
		}

		private function overwriteMapping(mapping:ICommandMapping):ICommandMappingConfig
		{
			_logger && _logger.warn('{0} already mapped to {1}\n' +
				'If you have overridden this mapping intentionally you can use "unmap()" ' +
				'prior to your replacement mapping in order to avoid seeing this message.\n',
				[_trigger, mapping]);
			deleteMapping(mapping);
			return createMapping(mapping.commandClass);
		}
	}
}
