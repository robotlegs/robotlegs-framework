//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMapA.api
{
	import flash.display.DisplayObject;

	public interface IMediatorTrigger
	{
		function startup(mediator:*, view:DisplayObject):void;

		function shutdown(mediator:*, view:DisplayObject, callback:Function):void;
	}
}
