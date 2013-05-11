//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.impl
{
	import flash.utils.Dictionary;
	import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorMapping;

	/**
	 * @private
	 */
	public class ViewProcessorViewHandler implements IViewProcessorViewHandler
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _mappings:Array = [];

		private var _knownMappings:Dictionary = new Dictionary(true);

		private var _factory:IViewProcessorFactory;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function ViewProcessorViewHandler(factory:IViewProcessorFactory):void
		{
			_factory = factory;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function addMapping(mapping:IViewProcessorMapping):void
		{
			const index:int = _mappings.indexOf(mapping);
			if (index > -1)
				return;
			_mappings.push(mapping);
			flushCache();
		}

		/**
		 * @inheritDoc
		 */
		public function removeMapping(mapping:IViewProcessorMapping):void
		{
			const index:int = _mappings.indexOf(mapping);
			if (index == -1)
				return;
			_mappings.splice(index, 1);
			flushCache();
		}

		/**
		 * @inheritDoc
		 */
		public function processItem(item:Object, type:Class):void
		{
			const interestedMappings:Array = getInterestedMappingsFor(item, type);
			if (interestedMappings)
				_factory.runProcessors(item, type, interestedMappings);
		}

		/**
		 * @inheritDoc
		 */
		public function unprocessItem(item:Object, type:Class):void
		{
			const interestedMappings:Array = getInterestedMappingsFor(item, type);
			if (interestedMappings)
				_factory.runUnprocessors(item, type, interestedMappings);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function flushCache():void
		{
			_knownMappings = new Dictionary(true);
		}

		private function getInterestedMappingsFor(view:Object, type:Class):Array
		{
			var mapping:IViewProcessorMapping;

			// we've seen this type before and nobody was interested
			if (_knownMappings[type] === false)
				return null;

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
					return null;
			}

			// these mappings really do care
			return _knownMappings[type] as Array;
		}
	}
}
