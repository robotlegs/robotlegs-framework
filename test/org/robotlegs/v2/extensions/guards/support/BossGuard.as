//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.guards.support
{

	public class BossGuard
	{

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected var _approve:Boolean;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function BossGuard(approve:Boolean)
		{
			_approve = approve;
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function approve():Boolean
		{
			return _approve;
		}
	}

}

