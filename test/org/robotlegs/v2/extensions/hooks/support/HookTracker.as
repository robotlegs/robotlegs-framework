package org.robotlegs.v2.extensions.hooks.support 
{
	public class HookTracker
	{
		public var hooksConfirmed:Vector.<String> = new Vector.<String>();

		public function HookTracker()
		{
			
		}

		public function confirm(hookName:String):void
		{
			hooksConfirmed.push(hookName);
		}
	}

}
