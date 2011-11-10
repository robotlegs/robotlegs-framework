//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMapA.support
{
	import flash.display.DisplayObject;
	import org.robotlegs.v2.extensions.mediatorMapA.api.IMediatorTrigger;

	public class DuckTypedRL1MediatorTrigger implements IMediatorTrigger
	{

		protected var _strict:Boolean;

		public function DuckTypedRL1MediatorTrigger(strict:Boolean)
		{
			_strict = strict;
		}

		// TODO - in strict mode, always run the code
		// - in relaxed mode, defend against missing api

		public function startup(mediator:*, view:DisplayObject):void
		{
			mediator.preRegister();
		}

		public function shutdown(mediator:*, view:DisplayObject, callback:Function):void
		{
			mediator.preRemove();
			callback(mediator, view);
		}
	}
}
