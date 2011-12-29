//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.guards.support
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

