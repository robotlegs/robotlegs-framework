//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.enhancedLogging
{
	import robotlegs.bender.extensions.enhancedLogging.impl.TraceLogTargetTest;

	[RunWith("org.flexunit.runners.Suite")]
	[Suite]
	public class EnhancedLoggingExtensionTestSuite
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public var loggingExtension:InjectableLoggerExtensionTest;

		public var traceLoggingExtension:TraceLoggingExtensionTest;

		public var traceLogTarget:TraceLogTargetTest;

		public var injectorLoggingExtension:InjectorActivityLoggingExtensionTest;
	}
}
