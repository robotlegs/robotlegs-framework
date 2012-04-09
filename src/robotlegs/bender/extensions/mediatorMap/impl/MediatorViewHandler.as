//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorViewHandler;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;

	public class MediatorViewHandler implements IMediatorViewHandler
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _mappings:Array = [];

		private var _knownMappings:Dictionary = new Dictionary(true);

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function addMapping(mapping:IMediatorMapping):void
		{
			const index:int = _mappings.indexOf(mapping);
			if (index > -1)
				return;
			_mappings.push(mapping);
			flushCache();
		}

		public function removeMapping(mapping:IMediatorMapping):void
		{
			const index:int = _mappings.indexOf(mapping);
			if (index == -1)
				return;
			_mappings.splice(index, 1);
			flushCache();
		}

		public function handleView(view:DisplayObject, type:Class):void
		{
			var mapping:IMediatorMapping;

			// we've seen this type before and nobody was interested
			if (_knownMappings[type] === false)
				return;

			// we haven't seen this type before
			if (_knownMappings[type] == undefined)
			{
				_knownMappings[type] = false;
				for each (mapping in _mappings)
				{
					if (mapping.matcher.matches(view))
					{
						_knownMappings[type] ||= [];
						_knownMappings[type].push(mapping);
					}
				}
				// nobody cares, let's get out of here
				if (_knownMappings[type] === false)
					return;
			}

			// these mappings really do care
			const interestedMappings:Array = _knownMappings[type] as Array;
			for each (mapping in interestedMappings)
			{
				mapping.createMediator(view);
			}
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function flushCache():void
		{
			_knownMappings = new Dictionary(true);
		}
	}
}
