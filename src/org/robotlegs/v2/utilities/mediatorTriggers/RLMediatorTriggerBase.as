//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.utilities.mediatorTriggers
{
	import flash.display.DisplayObject;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorTrigger;

	public class RLMediatorTriggerBase implements IMediatorTrigger
	{

		protected var _mediatorType:Class;

		protected var _strict:Boolean;

		public function RLMediatorTriggerBase(strict:Boolean, mediatorType:Class)
		{
			_strict = strict;
			_mediatorType = mediatorType;
		}

		public function startup(mediator:*, view:DisplayObject):void
		{
			if (_strict || (mediator is _mediatorType))
			{
				mediator.setViewComponent(view);
				mediator.preRegister();
			}
		}

		public function shutdown(mediator:*, view:DisplayObject, callback:Function):void
		{
			if (_strict || (mediator is _mediatorType))
			{
				mediator.preRemove();
			}

			callback(mediator, view);
		}
	}
}
