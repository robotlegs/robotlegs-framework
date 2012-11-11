//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;

	public class CommandMappingList
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _head:ICommandMapping;

		public function get head():ICommandMapping
		{
			return _head;
		}

		private var _tail:ICommandMapping;

		public function get tail():ICommandMapping
		{
			return _tail;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function add(node:ICommandMapping):void
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

		public function remove(node:ICommandMapping):void
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
	}
}
