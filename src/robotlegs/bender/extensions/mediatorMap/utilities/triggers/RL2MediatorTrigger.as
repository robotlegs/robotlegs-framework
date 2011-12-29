//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.utilities.triggers
{
	import robotlegs.bender.extensions.mediatorMap.api.IMediator;
	import flash.display.DisplayObject;

	public class RL2MediatorTrigger extends StrategicTriggerBase
	{
		protected var _strict:Boolean;

		public function RL2MediatorTrigger(strict:Boolean)
		{
			_strict = strict;
		}

		override public function startup(mediator:*, view:DisplayObject):void
		{
			if (_strict || (mediator is IMediator))
			{
				mediator.destroyed = false;
				mediator.setViewComponent(view);
				startupWithStrategy(mediator, view);
			}
		}

		override public function shutdown(mediator:*, view:DisplayObject, callback:Function):void
		{
			if (_strict || (mediator is IMediator))
			{
				mediator.destroy();
				mediator.destroyed = true;
			}
			callback(mediator, view);
		}

		override protected function startupCallback(mediator:*):void
		{
			mediator.initialize();
		}
	}
}