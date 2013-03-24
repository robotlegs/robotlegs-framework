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

		private var _head:ICommandMapping;

		public function get head():ICommandMapping
		{
			return _head;
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

		private var _tail:ICommandMapping;

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
				_head || _trigger.activate();
				storeMapping(mapping);
			}
		}

		public function removeMapping(mapping:ICommandMapping):void
		{
			deleteMapping(mapping);
			_head || _trigger.deactivate();
		}

		public function removeMappingFor(commandClass:Class):void
		{
			const mapping:ICommandMapping = _mappingsByCommand[commandClass];
			mapping && removeMapping(mapping);
		}

		public function removeAllMappings():void
		{
			for (var mapping:ICommandMapping = _head; mapping; mapping = mapping.next)
			{
				deleteMapping(mapping);
			}
			_trigger.deactivate();
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function addNode(node:ICommandMapping):void
		{
			if (_tail)
			{
				_tail.next = node;
				node.previous = _tail;
				_tail = node;
			}
			else
			{
				_head = _tail = node;
			}
		}

		private function removeNode(node:ICommandMapping):void
		{
			if (node == _head)
			{
				_head = _head.next;
			}
			if (node == _tail)
			{
				_tail = _tail.previous;
			}
			if (node.previous)
			{
				node.previous.next = node.next;
			}
			if (node.next)
			{
				node.next.previous = node.previous;
			}
		}

		private function storeMapping(mapping:ICommandMapping):void
		{
			_mappingsByCommand[mapping.commandClass] = mapping;
			addNode(mapping);
			_logger && _logger.debug('{0} mapped to {1}', [_trigger, mapping]);
		}

		private function deleteMapping(mapping:ICommandMapping):void
		{
			delete _mappingsByCommand[mapping.commandClass];
			removeNode(mapping);
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
