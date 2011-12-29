//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandMap.support
{

	public class SelfReportingCallbackHook
	{

		[Inject]
		public var command:SelfReportingCallbackCommand;

		[Inject(name="hookCallback")]
		public var callback:Function;

		public function hook():void
		{
			callback(this);
		}
	}
}
