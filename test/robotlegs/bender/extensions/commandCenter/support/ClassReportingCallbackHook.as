//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.support
{

	public class ClassReportingCallbackHook
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Inject(name="reportingFunction")]
		public var reportingFunc:Function;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function hook():void
		{
			reportingFunc && reportingFunc(ClassReportingCallbackHook);
		}
	}
}
