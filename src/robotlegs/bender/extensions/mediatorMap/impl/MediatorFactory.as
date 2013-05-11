//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.matching.ITypeFilter;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
	import robotlegs.bender.extensions.mediatorMap.api.MediatorFactoryEvent;
	import robotlegs.bender.framework.impl.applyHooks;
	import robotlegs.bender.framework.impl.guardsApprove;

	[Event(name="mediatorCreate", type="robotlegs.bender.extensions.mediatorMap.api.MediatorFactoryEvent")]
	[Event(name="mediatorRemove", type="robotlegs.bender.extensions.mediatorMap.api.MediatorFactoryEvent")]
	/**
	 * @private
	 */
	public class MediatorFactory extends EventDispatcher implements IMediatorFactory
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _mediators:Dictionary = new Dictionary();

		private var _injector:Injector;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function MediatorFactory(injector:Injector)
		{
			_injector = injector;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function getMediator(item:Object, mapping:IMediatorMapping):Object
		{
			return _mediators[item] ? _mediators[item][mapping] : null;
		}

		/**
		 * @inheritDoc
		 */
		public function createMediators(item:Object, type:Class, mappings:Array):Array
		{
			const createdMediators:Array = [];
			var filter:ITypeFilter;
			var mediator:Object;
			for each (var mapping:IMediatorMapping in mappings)
			{
				mediator = getMediator(item, mapping);

				if (!mediator)
				{
					filter = mapping.matcher;
					mapTypeForFilterBinding(filter, type, item);
					mediator = createMediator(item, mapping);
					unmapTypeForFilterBinding(filter, type, item)
				}

				if (mediator)
					createdMediators.push(mediator);
			}
			return createdMediators;
		}

		/**
		 * @inheritDoc
		 */
		public function removeMediators(item:Object):void
		{
			const mediators:Dictionary = _mediators[item];
			if (!mediators)
				return;

			if (hasEventListener(MediatorFactoryEvent.MEDIATOR_REMOVE))
			{
				for (var mapping:Object in mediators)
				{
					dispatchEvent(new MediatorFactoryEvent(
						MediatorFactoryEvent.MEDIATOR_REMOVE,
						mediators[mapping], item, mapping as IMediatorMapping, this));
				}
			}

			delete _mediators[item];
		}

		/**
		 * @inheritDoc
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
			if (hasEventListener(MediatorFactoryEvent.MEDIATOR_CREATE))
				dispatchEvent(new MediatorFactoryEvent(
					MediatorFactoryEvent.MEDIATOR_CREATE,
					mediator, item, mapping, this));
		}

		private function mapTypeForFilterBinding(filter:ITypeFilter, type:Class, item:Object):void
		{
			var requiredType:Class;
			const requiredTypes:Vector.<Class> = requiredTypesFor(filter, type);

			for each (requiredType in requiredTypes)
			{
				_injector.map(requiredType).toValue(item);
			}
		}

		private function unmapTypeForFilterBinding(filter:ITypeFilter, type:Class, item:Object):void
		{
			var requiredType:Class;
			const requiredTypes:Vector.<Class> = requiredTypesFor(filter, type);

			for each (requiredType in requiredTypes)
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
