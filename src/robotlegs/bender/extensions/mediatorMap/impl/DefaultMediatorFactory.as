//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
	import robotlegs.bender.framework.guard.impl.guardsApprove;
	import robotlegs.bender.framework.hook.impl.applyHooks;

	public class DefaultMediatorFactory implements IMediatorFactory
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _injector:Injector;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function DefaultMediatorFactory(injector:Injector)
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
			var mediator:Object;

			const viewType:Class = mapping.viewType || view['constructor'];
			_injector.map(viewType).toValue(view);

			if (guardsApprove(mapping.guards, _injector))
			{
				mediator = _injector.getInstance(mapping.mediatorClass);
				_injector.map(mapping.mediatorClass).toValue(mediator);
				applyHooks(mapping.hooks, _injector);
				_injector.unmap(mapping.mediatorClass);
			}

			_injector.unmap(viewType);
			return mediator;
		}
	}
}
