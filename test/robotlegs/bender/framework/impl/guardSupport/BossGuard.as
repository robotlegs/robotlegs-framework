//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl.guardSupport
{

	public class BossGuard
	{

		protected var _approve:Boolean;

		public function BossGuard(approve:Boolean)
		{
			_approve = approve;
		}

		public function approve():Boolean
		{
			return _approve;
		}
	}

}

