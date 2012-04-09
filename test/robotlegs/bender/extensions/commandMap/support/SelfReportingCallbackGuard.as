//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandMap.support
{

	public class SelfReportingCallbackGuard
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Inject(name="approveCallback")]
		public var callback:Function;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function approve():Boolean
		{
			callback(this);
			return true;
		}
	}
}
