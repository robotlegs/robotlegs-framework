//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.hooks.support
{

	public class TrackableHook1
	{

		[Inject]
		public var hookTracker:HookTracker;

		public function hook():void
		{
			hookTracker.confirm("TrackableHook1");
		}
	}

}

