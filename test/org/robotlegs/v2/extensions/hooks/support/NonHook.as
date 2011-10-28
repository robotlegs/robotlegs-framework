package org.robotlegs.v2.extensions.hooks.support
{

	public class NonHook
	{
		[Inject]
		public var hookTracker:HookTracker;

		public function noHooksHere():void
		{
			hookTracker.confirm("NonHook");
		}
	}

}

