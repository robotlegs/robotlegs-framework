package robotlegs.bender.extensions.commandCenter.impl
{
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;

	public class CommandMappingList
	{
	
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
			if(!_head) return null;
			
			var theTail:ICommandMapping = _head;
			while(theTail.next)
			{
				theTail = theTail.next
			}
			return theTail;
		}
		
		public function remove(item:ICommandMapping):void
		{
			var link:ICommandMapping = _head;
			if(link == item)
			{
				_head = item.next;
			}
			while(link)
			{
				if(link.next == item)
				{
					link.next = item.next;
				}
				link = link.next;
			}
		}
	}
}