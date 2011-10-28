package org.robotlegs.v2.extensions.hooks.support 
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

