//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
	import robotlegs.bender.extensions.mediatorMap.api.MediatorFactoryEvent;
	import robotlegs.bender.extensions.matching.ITypeFilter;
	import robotlegs.bender.framework.impl.applyHooks;
	import robotlegs.bender.framework.impl.guardsApprove;

	[Event(name="mediatorCreate", type="robotlegs.bender.extensions.mediatorMap.api.MediatorFactoryEvent")]
	[Event(name="mediatorRemove", type="robotlegs.bender.extensions.mediatorMap.api.MediatorFactoryEvent")]
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

		public function MediatorFactory(injector:Injector)
		{
			_injector = injector;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function getMediator(item:Object, mapping:IMediatorMapping):Object
		{
			return _mediators[item] ? _mediators[item][mapping] : null;
		}
		
		public function createMediators(item:Object, type:Class, mappings:Array):Array
		{
			const createdMediators:Array = [];
			var filter:ITypeFilter;
			var mediator:Object;
			for each (var mapping:IMediatorMapping in mappings)
			{
				mapping.validate();
				mediator = getMediator(item, mapping);

				if (!mediator)
				{
					filter = mapping.matcher;
					mapTypeForFilterBinding(filter, type, item);
					mediator = createMediator(item, mapping);
					unmapTypeForFilterBinding(filter, type, item)
				}
				
				if(mediator)
					createdMediators.push(mediator);
			}
			return createdMediators;
		}
		
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
			
			if (guardsApprove(mapping.guards, _injector))
			{
				_injector.map(mapping.mediatorClass).asSingleton();
				mediator = _injector.getInstance(mapping.mediatorClass);
				applyHooks(mapping.hooks, _injector);
				_injector.unmap(mapping.mediatorClass);
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
				if(_injector.satisfiesDirectly(requiredType))
					_injector.unmap(requiredType);
			}
		}
		
		private function requiredTypesFor(filter:ITypeFilter, type:Class):Vector.<Class>
		{
			const requiredTypes:Vector.<Class> = filter.allOfTypes.concat(filter.anyOfTypes);

			if(requiredTypes.indexOf(type) == -1)
				requiredTypes.push(type);
			
			return requiredTypes;
		}
	}
}