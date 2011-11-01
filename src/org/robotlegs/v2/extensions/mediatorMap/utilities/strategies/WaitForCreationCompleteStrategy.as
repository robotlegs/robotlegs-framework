//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.utilities.strategies
{
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediator;
	import flash.display.DisplayObject;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorTrigger;
	import flash.utils.Dictionary;
	import org.robotlegs.v2.core.api.ITypeMatcher;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorStartupStrategy;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class WaitForCreationCompleteStrategy implements IMediatorStartupStrategy
	{
		protected const _callbacksByView:Dictionary = new Dictionary();
		protected const _mediatorsByView:Dictionary = new Dictionary();
		
		// avoids the flex framework being required
		protected static const CREATION_COMPLETE:String = 'creationComplete';

		public function startup(mediator:*, view:DisplayObject, callback:Function):void
		{
			if(view['initialized'])
			{
				callback(mediator);
				return;
			}
			
			_callbacksByView[view] = callback;
			_mediatorsByView[view] = mediator;
			view.addEventListener(CREATION_COMPLETE, completeStartup);
		}

		protected function completeStartup(e:Event):void
		{
			const view:EventDispatcher = e.target as EventDispatcher;
			view.removeEventListener(CREATION_COMPLETE, completeStartup);
			
			if(!_mediatorsByView[view].destroyed)
			{
				_callbacksByView[view](_mediatorsByView[view]);
			}

			delete _callbacksByView[view];
			delete _mediatorsByView[view];
		}
	}
}