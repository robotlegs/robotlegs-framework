//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import flash.utils.Dictionary;
	import robotlegs.bender.extensions.matching.ITypeFilter;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.impl.applyHooks;
	import robotlegs.bender.framework.impl.guardsApprove;

	/**
	 * @private
	 */
	public class MediatorFactory
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _mediators:Dictionary = new Dictionary();

		private var _injector:IInjector;

		private var _manager:MediatorManager;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function MediatorFactory(injector:IInjector, manager:MediatorManager = null)
		{
			_injector = injector;
			_manager = manager || new MediatorManager(this);
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function getMediator(item:Object, mapping:IMediatorMapping):Object
		{
			return _mediators[item] ? _mediators[item][mapping] : null;
		}

		/**
		 * @private
		 */
		public function createMediators(item:Object, type:Class, mappings:Array):Array
		{
			const createdMediators:Array = [];
			var mediator:Object;
			for each (var mapping:IMediatorMapping in mappings)
			{
				mediator = getMediator(item, mapping);

				if (!mediator)
				{
					mapTypeForFilterBinding(mapping.matcher, type, item);
					mediator = createMediator(item, mapping);
					unmapTypeForFilterBinding(mapping.matcher, type, item)
				}

				if (mediator)
					createdMediators.push(mediator);
			}
			return createdMediators;
		}

		/**
		 * @private
		 */
		public function removeMediators(item:Object):void
		{
			const mediators:Dictionary = _mediators[item];
			if (!mediators)
				return;

			for (var mapping:Object in mediators)
			{
				_manager.removeMediator(mediators[mapping], item, mapping as IMediatorMapping);
			}

			delete _mediators[item];
		}

		/**
		 * @private
		 */
		public function removeAllMediators():void
		{
			for (var item:Object in _mediators)
			{
				removeMediators(item);
			}
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function createMediator(item:Object, mapping:IMediatorMapping):Object
		{
			var mediator:Object = getMediator(item, mapping);

			if (mediator)
				return mediator;

			if (mapping.guards.length == 0 || guardsApprove(mapping.guards, _injector))
			{
				const mediatorClass:Class = mapping.mediatorClass;
				mediator = _injector.instantiateUnmapped(mediatorClass);
				if (mapping.hooks.length > 0)
				{
					_injector.map(mediatorClass).toValue(mediator);
					applyHooks(mapping.hooks, _injector);
					_injector.unmap(mediatorClass);
				}
				addMediator(mediator, item, mapping);
			}
			return mediator;
		}

		private function addMediator(mediator:Object, item:Object, mapping:IMediatorMapping):void
		{
			_mediators[item] ||= new Dictionary();
			_mediators[item][mapping] = mediator;
			_manager.addMediator(mediator, item, mapping);
		}

		private function mapTypeForFilterBinding(filter:ITypeFilter, type:Class, item:Object):void
		{
			for each (var requiredType:Class in requiredTypesFor(filter, type))
			{
				_injector.map(requiredType).toValue(item);
			}
		}

		private function unmapTypeForFilterBinding(filter:ITypeFilter, type:Class, item:Object):void
		{
			for each (var requiredType:Class in requiredTypesFor(filter, type))
			{
				if (_injector.satisfiesDirectly(requiredType))
					_injector.unmap(requiredType);
			}
		}

		private function requiredTypesFor(filter:ITypeFilter, type:Class):Vector.<Class>
		{
			const requiredTypes:Vector.<Class> = filter.allOfTypes.concat(filter.anyOfTypes);

			if (requiredTypes.indexOf(type) == -1)
				requiredTypes.push(type);

			return requiredTypes;
		}
	}
}
