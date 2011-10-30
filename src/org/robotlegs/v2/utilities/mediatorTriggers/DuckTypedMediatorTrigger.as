//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.utilities.mediatorTriggers
{
	import flash.display.DisplayObject;
	import flash.utils.describeType;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorTrigger;
	import org.robotlegs.v2.extensions.utils.objectHasMethod;

	public class DuckTypedMediatorTrigger implements IMediatorTrigger
	{

		protected var _strict:Boolean;

		public function DuckTypedMediatorTrigger(strict:Boolean)
		{
			_strict = strict;
		}

		public function startup(mediator:*, view:DisplayObject):void
		{
			if (_strict)
			{
				mediator.setViewComponent(view);
				mediator.preRegister();
				return;
			}

			if (objectHasMethod(mediator, 'setViewComponent'))
			{
				mediator.setViewComponent(view);
			}
			if (objectHasMethod(mediator, 'preRegister'))
			{
				mediator.preRegister();
			}
		}

		public function shutdown(mediator:*, view:DisplayObject, callback:Function):void
		{
			if (_strict)
			{
				mediator.preRemove();
			}
			else if (objectHasMethod(mediator, 'preRemove'))
			{
				mediator.preRemove();
			}
			callback(mediator, view);
		}
	}
}
