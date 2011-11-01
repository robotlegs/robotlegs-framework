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

	public class RL2MediatorTrigger implements IMediatorTrigger
	{
		protected var _strict:Boolean;

		public function RL2MediatorTrigger(strict:Boolean)
		{
			_strict = strict;
		}

		public function startup(mediator:*, view:DisplayObject):void
		{
			trace("RL2MediatorTrigger::startup()");
			if (_strict || (mediator is IMediator))
			{
				mediator.setViewComponent(view);
				mediator.initialize();
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
	}
}