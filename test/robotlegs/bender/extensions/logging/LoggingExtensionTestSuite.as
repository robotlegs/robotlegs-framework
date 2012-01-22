//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.logging
{
	import robotlegs.bender.extensions.logging.impl.TraceLogTargetTest;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class LoggingExtensionTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var loggingExtension:LoggingExtensionTest;

		public var traceLoggingExtension:TraceLoggingExtensionTest;

		public var traceLogTarget:TraceLogTargetTest;
	}
}
