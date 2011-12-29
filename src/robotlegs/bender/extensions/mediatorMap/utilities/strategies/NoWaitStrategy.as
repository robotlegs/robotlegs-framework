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

	public class NoWaitStrategy implements IMediatorStartupStrategy
	{
		public function startup(mediator:*, view:DisplayObject, callback:Function):void
		{
			callback(mediator);
		}
	}
}