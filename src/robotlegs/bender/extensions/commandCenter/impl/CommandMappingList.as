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

		protected var _head:ICommandMapping;

		public function get head():ICommandMapping
		{
			return _head;
		}

		public function set head(value:ICommandMapping):void
		{
			if (value !== _head)
			{
				_head = value;
			}
		}

		public function get tail():ICommandMapping
		{
			if (!_head) return null;

			var theTail:ICommandMapping = _head;
			while (theTail.next)
			{
				theTail = theTail.next
			}
			return theTail;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function remove(item:ICommandMapping):void
		{
			var link:ICommandMapping = _head;
			if (link == item)
			{
				_head = item.next;
			}
			while (link)
			{
				if (link.next == item)
				{
					link.next = item.next;
				}
				link = link.next;
			}
		}
	}
}
