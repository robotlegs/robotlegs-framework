//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.commandMap.support
{
	import flash.events.Event;

	public class SelfReportingCallbackGuard
	{

		[Inject]
		public var event:Event;

		[Inject(name="approveCallback")]
		public var callback:Function;

		public function approve():Boolean
		{
			callback(this);
			return true;
		}
	}
}
