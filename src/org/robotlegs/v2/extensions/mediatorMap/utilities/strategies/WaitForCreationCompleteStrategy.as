//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.utilities.strategies
{
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediator;
	import flash.display.DisplayObject;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorTrigger;
	import flash.utils.Dictionary;
	import org.robotlegs.v2.core.api.ITypeMatcher;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorStartupStrategy;

	public class WaitForCreationCompleteStrategy implements IMediatorStartupStrategy
	{
		public function startup(mediator:*, view:DisplayObject, callback:Function):void
		{
			//callback(mediator);
		}
	}
}