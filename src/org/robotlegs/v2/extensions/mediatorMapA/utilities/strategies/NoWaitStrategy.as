//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMapA.utilities.strategies
{
	import flash.display.DisplayObject;
	import org.robotlegs.v2.extensions.mediatorMapA.api.IMediatorStartupStrategy;

	public class NoWaitStrategy implements IMediatorStartupStrategy
	{
		public function startup(mediator:*, view:DisplayObject, callback:Function):void
		{
			callback(mediator);
		}
	}
}