package org.robotlegs.v2.extensions.hooks.support 
{

	public class TrackableHook2
	{
		[Inject]
		public var hookTracker:HookTracker;

		public function hook():void
		{
			hookTracker.confirm("TrackableHook2");
		}
	}


}

