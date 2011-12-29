//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.utilities.strategies
{
	import flash.display.DisplayObject;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorStartupStrategy;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	public class WaitForCompleteStrategy implements IMediatorStartupStrategy
	{
		private const _callbacksByView:Dictionary = new Dictionary();
		private const _mediatorsByView:Dictionary = new Dictionary();

		public function startup(mediator:*, view:DisplayObject, callback:Function):void
		{
			_callbacksByView[view] = callback;
			_mediatorsByView[view] = mediator;
			view.addEventListener(Event.COMPLETE, completeStartup);
		}

		private function completeStartup(e:Event):void
		{
			const view:EventDispatcher = e.target as EventDispatcher;
			view.removeEventListener(Event.COMPLETE, completeStartup);

			if(!_mediatorsByView[view].destroyed)
			{
				_callbacksByView[view](_mediatorsByView[view]);
			}

			delete _callbacksByView[view];
			delete _mediatorsByView[view];
		}
	}
}