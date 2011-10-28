package org.robotlegs.v2.extensions.guards.support
{

	public class JustTheMiddleManGuard
	{
		[Inject]
		public var bossDecision:BossGuard;

		public function approve():Boolean
		{
			return bossDecision.approve();
		}
	}

}

