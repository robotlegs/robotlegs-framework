//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.vigilance
{
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.bender.framework.impl.Context;

	public class VigilanceExtensionTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var logger:ILogger;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			logger = new Context()
				.extend(VigilanceExtension)
				.getLogger(this);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function extension_does_NOT_throw_for_DEBUG():void
		{
			logger.debug("");
		}

		[Test]
		public function extension_does_NOT_throw_for_INFO():void
		{
			logger.info("");
		}

		[Test(expects="Error")]
		public function extension_throws_for_WARNING():void
		{
			logger.warn("");
		}

		[Test(expects="Error")]
		public function extension_throws_for_ERROR():void
		{
			logger.error("");
		}

		[Test(expects="Error")]
		public function extension_throws_for_FATAL():void
		{
			logger.fatal("");
		}
	}
}
