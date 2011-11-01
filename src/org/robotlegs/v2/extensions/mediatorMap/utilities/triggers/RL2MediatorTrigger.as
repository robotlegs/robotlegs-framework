//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.utilities.triggers
{
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediator;
	import flash.display.DisplayObject;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorTrigger;
	import flash.utils.Dictionary;
	import org.robotlegs.v2.core.api.ITypeMatcher;
	import org.robotlegs.v2.extensions.mediatorMap.utilities.strategies.NoWaitStrategy;
	import org.robotlegs.v2.core.api.ITypeFilter;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorStartupStrategy;

	public class RL2MediatorTrigger implements IMediatorTrigger
	{
		protected var _strict:Boolean;
		
		protected const _strategiesByFilter:Dictionary = new Dictionary();
				
		protected var _defaultStrategy:IMediatorStartupStrategy = new NoWaitStrategy();

		public function RL2MediatorTrigger(strict:Boolean)
		{
			_strict = strict;
		}

		public function startup(mediator:*, view:DisplayObject):void
		{
			if (_strict || (mediator is IMediator))
			{
				mediator.setViewComponent(view);
				startupWithStrategy(mediator, view);
			}
		}

		public function shutdown(mediator:*, view:DisplayObject, callback:Function):void
		{
			if (_strict || (mediator is IMediator))
			{
				mediator.destroy();
			}
			callback(mediator, view);
		}
		
		public function addStartupStrategy(strategy:Class, matcher:ITypeMatcher):void
		{

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
			mediator.initialize();
		}
	}
}