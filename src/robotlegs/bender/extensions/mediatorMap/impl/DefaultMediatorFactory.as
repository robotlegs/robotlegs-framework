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

	public class DefaultMediatorFactory implements IMediatorFactory
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _injector:Injector;

		public function get injector():Injector
		{
			return _injector;
		}

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

		public function createMediator(view:Object, mapping:IMediatorMapping):Object
		{
			var mediator:Object;

			const viewType:Class = mapping.viewType || view['constructor'];
			_injector.map(viewType).toValue(view);

			if (mapping.guards.approve())
			{
				mediator = _injector.getInstance(mapping.mediatorClass);
				_injector.map(mapping.mediatorClass).toValue(mediator);
				mapping.hooks.hook();
				_injector.unmap(mapping.mediatorClass);
			}

			_injector.unmap(viewType);
			return mediator;
		}
	}
}
