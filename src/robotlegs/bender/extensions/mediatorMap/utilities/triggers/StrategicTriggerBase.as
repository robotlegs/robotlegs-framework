//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.utilities.triggers
{
	import flash.display.DisplayObject;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorTrigger;
	import flash.utils.Dictionary;
	import robotlegs.bender.core.api.ITypeMatcher;
	import robotlegs.bender.extensions.mediatorMap.utilities.strategies.NoWaitStrategy;
	import robotlegs.bender.core.api.ITypeFilter;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorStartupStrategy;
	import robotlegs.bender.extensions.mediatorMap.api.IStrategicTrigger;

	public class StrategicTriggerBase implements IMediatorTrigger, IStrategicTrigger
	{
		protected const _strategiesByFilter:Dictionary = new Dictionary();

		protected var _defaultStrategy:IMediatorStartupStrategy = new NoWaitStrategy();

		public function startup(mediator:*, view:DisplayObject):void
		{
		}

		public function shutdown(mediator:*, view:DisplayObject, callback:Function):void
		{
		}

		public function addStartupStrategy(strategy:Class, matcher:ITypeMatcher):void
		{
			_strategiesByFilter[matcher.createTypeFilter()] = new strategy();
		}

		protected function startupWithStrategy(mediator:*, view:DisplayObject):void
		{
			for (var filter:* in _strategiesByFilter)
			{
				if((filter as ITypeFilter).matches(view))
				{
					_strategiesByFilter[filter].startup(mediator, view, startupCallback);
					return;
				}
			}

			_defaultStrategy.startup(mediator, view, startupCallback);
		}

		protected function startupCallback(mediator:*):void
		{
		}
	}
}