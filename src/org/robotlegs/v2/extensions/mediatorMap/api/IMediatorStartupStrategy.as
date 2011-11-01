//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.api
{
	import flash.display.DisplayObject;

	public interface IMediatorStartupStrategy
	{
		function startup(mediator:*, view:DisplayObject, callback:Function):void;
	}
}
