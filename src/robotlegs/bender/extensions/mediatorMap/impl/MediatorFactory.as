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
	import robotlegs.bender.framework.guard.impl.guardsApprove;
	import robotlegs.bender.framework.hook.impl.applyHooks;

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

		/**
		 * @inheritDoc
		 */
		public function createMediator(view:Object, mapping:IMediatorMapping):Object
		{
			var mediator:Object = getMediator(view, mapping);

			if (mediator)
				return mediator;

			const viewType:Class = mapping.viewType || view['constructor'];
			_injector.map(viewType).toValue(view);

			if (guardsApprove(mapping.guards, _injector))
			{
				mediator = _injector.getInstance(mapping.mediatorClass);
				_injector.map(mapping.mediatorClass).toValue(mediator);
				applyHooks(mapping.hooks, _injector);
				_injector.unmap(mapping.mediatorClass);
				addMediator(mediator, view, mapping);
			}

			_injector.unmap(viewType);
			return mediator;
		}

		public function getMediator(view:Object, mapping:IMediatorMapping):Object
		{
			return _mediators[view] ? _mediators[view][mapping] : null;
		}

		public function removeMediator(view:Object, mapping:IMediatorMapping):void
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

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function addMediator(mediator:Object, view:Object, mapping:IMediatorMapping):void
		{
			_mediators[view] ||= new Dictionary();
			_mediators[view][mapping] = mediator;
			if (hasEventListener(MediatorFactoryEvent.MEDIATOR_CREATE))
				dispatchEvent(new MediatorFactoryEvent(
					MediatorFactoryEvent.MEDIATOR_CREATE,
					mediator, view, mapping, this));
		}
	}
}
