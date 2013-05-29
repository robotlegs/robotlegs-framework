//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import flash.display.DisplayObject;
	import flash.utils.Dictionary;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
	import robotlegs.bender.extensions.viewManager.api.IViewHandler;

	/**
	 * @private
	 */
	public class MediatorViewHandler implements IViewHandler
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _mappings:Array = [];

		private var _knownMappings:Dictionary = new Dictionary(true);

		private var _factory:MediatorFactory;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function MediatorViewHandler(factory:MediatorFactory):void
		{
			_factory = factory;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function addMapping(mapping:IMediatorMapping):void
		{
			const index:int = _mappings.indexOf(mapping);
			if (index > -1)
				return;
			_mappings.push(mapping);
			flushCache();
		}

		/**
		 * @private
		 */
		public function removeMapping(mapping:IMediatorMapping):void
		{
			const index:int = _mappings.indexOf(mapping);
			if (index == -1)
				return;
			_mappings.splice(index, 1);
			flushCache();
		}

		/**
		 * @private
		 */
		public function handleView(view:DisplayObject, type:Class):void
		{
			const interestedMappings:Array = getInterestedMappingsFor(view, type);
			if (interestedMappings)
				_factory.createMediators(view, type, interestedMappings);
		}

		/**
		 * @private
		 */
		public function handleItem(item:Object, type:Class):void
		{
			const interestedMappings:Array = getInterestedMappingsFor(item, type);
			if (interestedMappings)
				_factory.createMediators(item, type, interestedMappings);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function flushCache():void
		{
			_knownMappings = new Dictionary(true);
		}

		private function getInterestedMappingsFor(item:Object, type:Class):Array
		{
			var mapping:IMediatorMapping;

			// we've seen this type before and nobody was interested
			if (_knownMappings[type] === false)
				return null;

			// we haven't seen this type before
			if (_knownMappings[type] == undefined)
			{
				_knownMappings[type] = false;
				for each (mapping in _mappings)
				{
					if (mapping.matcher.matches(item))
					{
						_knownMappings[type] ||= [];
						_knownMappings[type].push(mapping);
					}
				}
				// nobody cares, let's get out of here
				if (_knownMappings[type] === false)
					return null;
			}

			// these mappings really do care
			return _knownMappings[type] as Array;
		}
	}
}
