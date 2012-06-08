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

		public function getMediator(view:Object, mapping:IMediatorMapping):Object
		{
			return _mediators[view] ? _mediators[view][mapping] : null;
		}
		
		public function createMediators(view:Object, type:Class, mappings:Array):Array
		{
			const createdMediators:Array = [];
			var filter:ITypeFilter;
			var mediator:Object;
			for each (var mapping:IMediatorMapping in mappings)
			{
				mediator = getMediator(view, mapping);

				if (!mediator)
				{
					filter = mapping.matcher;
					mapTypeForFilterBinding(filter, type, view);
					mediator = createMediator(view, mapping);
					unmapTypeForFilterBinding(filter, type, view)
				}
				
				if(mediator)
					createdMediators.push(mediator);
			}
			return createdMediators;
		}
		
		public function removeMediators(view:Object):void
		{
			const mediators:Dictionary = _mediators[view];
			if (!mediators)
				return;
			
			if (hasEventListener(MediatorFactoryEvent.MEDIATOR_REMOVE))
			{
				for (var mapping:Object in mediators)
				{
					dispatchEvent(new MediatorFactoryEvent(
						MediatorFactoryEvent.MEDIATOR_REMOVE,
						mediators[mapping], view, mapping as IMediatorMapping, this));
				}
			}
			
			delete _mediators[view];
		}
		
		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function createMediator(view:Object, mapping:IMediatorMapping):Object
		{
			var mediator:Object = getMediator(view, mapping);

			if (mediator)
				return mediator;
			
			if (guardsApprove(mapping.guards, _injector))
			{
				mediator = _injector.getInstance(mapping.mediatorClass);
				_injector.map(mapping.mediatorClass).toValue(mediator);
				applyHooks(mapping.hooks, _injector);
				_injector.unmap(mapping.mediatorClass);
				addMediator(mediator, view, mapping);
			}
			return mediator;
		}

		private function removeMediator(view:Object, mapping:IMediatorMapping):void
		{
			const mediators:Dictionary = _mediators[view];
			if (!mediators)
				return;
			const mediator:Object = mediators[mapping];
			if (!mediator)
				return;
			delete mediators[mapping];
			if (hasEventListener(MediatorFactoryEvent.MEDIATOR_REMOVE))
				dispatchEvent(new MediatorFactoryEvent(
					MediatorFactoryEvent.MEDIATOR_REMOVE,
					mediator, view, mapping, this));
		}

		private function addMediator(mediator:Object, view:Object, mapping:IMediatorMapping):void
		{
			_mediators[view] ||= new Dictionary();
			_mediators[view][mapping] = mediator;
			if (hasEventListener(MediatorFactoryEvent.MEDIATOR_CREATE))
				dispatchEvent(new MediatorFactoryEvent(
					MediatorFactoryEvent.MEDIATOR_CREATE,
					mediator, view, mapping, this));
		}
		
		private function mapTypeForFilterBinding(filter:ITypeFilter, type:Class, view:Object):void
		{
			var requiredType:Class;
			const requiredTypes:Vector.<Class> = requiredTypesFor(filter, type);

			for each (requiredType in requiredTypes)
			{
				_injector.map(requiredType).toValue(view);
			}
		}

		private function unmapTypeForFilterBinding(filter:ITypeFilter, type:Class, view:Object):void
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