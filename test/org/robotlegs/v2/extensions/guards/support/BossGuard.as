package org.robotlegs.v2.extensions.guards.support
{

	public class BossGuard
	{
		public function BossGuard(approve:Boolean)
		{
			_approve = approve;
		}

		protected var _approve:Boolean;

		public function approve():Boolean
		{
			return _approve;
		}
	}

}

