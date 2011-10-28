//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.support
{
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorTrigger;
	import flash.display.DisplayObject;

	public class DuckTypedRL1MediatorTrigger implements IMediatorTrigger 
	{
	
		public function DuckTypedRL1MediatorTrigger()
		{

		}
	
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