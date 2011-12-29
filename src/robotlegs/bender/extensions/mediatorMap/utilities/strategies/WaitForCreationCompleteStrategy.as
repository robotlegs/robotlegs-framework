//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.utilities.strategies
{
	import robotlegs.bender.extensions.mediatorMap.api.IMediator;
	import flash.display.DisplayObject;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorTrigger;
	import flash.utils.Dictionary;
	import robotlegs.bender.core.api.ITypeMatcher;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorStartupStrategy;
	import flash.events.Event;
	import flash.events.EventDispatcher;

	public class WaitForCreationCompleteStrategy implements IMediatorStartupStrategy
	{
		private const _callbacksByView:Dictionary = new Dictionary();
		private const _mediatorsByView:Dictionary = new Dictionary();

		// avoids the flex framework being required
		private static const CREATION_COMPLETE:String = 'creationComplete';

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

		private function completeStartup(e:Event):void
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