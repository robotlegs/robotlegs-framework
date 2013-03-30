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
	import robotlegs.bender.extensions.commandCenter.api.ICommandMappingList;
	import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
	import robotlegs.bender.framework.api.ILogger;

	public class CommandMappingList implements ICommandMappingList
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private const _mappings:Vector.<ICommandMapping> = new Vector.<ICommandMapping>;

		public function getList():Vector.<ICommandMapping>
		{
			return _mappings.concat();
		}

		private var _trigger:ICommandTrigger;

		public function set trigger(value:ICommandTrigger):void
		{
			_trigger = value;
		}

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _mappingsByCommand:Dictionary = new Dictionary();

		private var _logger:ILogger;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function CommandMappingList(logger:ILogger = null)
		{
			_logger = logger;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function addMapping(mapping:ICommandMapping):void
		{

			const oldMapping:ICommandMapping = _mappingsByCommand[mapping.commandClass];
			if (oldMapping)
			{
				overwriteMapping(oldMapping, mapping);
			}
			else
			{
				storeMapping(mapping);
				_mappings.length == 1 && _trigger.activate();
			}
		}

		public function removeMapping(mapping:ICommandMapping):void
		{
			if (_mappingsByCommand[mapping.commandClass])
			{
				deleteMapping(mapping);
				_mappings.length == 0 && _trigger.deactivate();
			}
		}

		public function removeMappingFor(commandClass:Class):void
		{
			const mapping:ICommandMapping = _mappingsByCommand[commandClass];
			mapping && removeMapping(mapping);
		}

		public function removeAllMappings():void
		{
			const list:Vector.<ICommandMapping> = getList();
			var length:int = list.length;
			while(length--)
			{
				deleteMapping(list[length]);
			}
			_trigger.deactivate();
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function storeMapping(mapping:ICommandMapping):void
		{
			_mappingsByCommand[mapping.commandClass] = mapping;
			_mappings.push(mapping);
			_logger && _logger.debug('{0} mapped to {1}', [_trigger, mapping]);
		}

		private function deleteMapping(mapping:ICommandMapping):void
		{
			delete _mappingsByCommand[mapping.commandClass];
			_mappings.splice(_mappings.indexOf(mapping), 1);
			_logger && _logger.debug('{0} unmapped from {1}', [_trigger, mapping]);
		}

		private function overwriteMapping(oldMapping:ICommandMapping, newMapping:ICommandMapping):void
		{
			_logger && _logger.warn('{0} already mapped to {1}\n' +
				'If you have overridden this mapping intentionally you can use "unmap()" ' +
				'prior to your replacement mapping in order to avoid seeing this message.\n',
				[_trigger, oldMapping]);
			deleteMapping(oldMapping);
			storeMapping(newMapping);
		}
	}
}
