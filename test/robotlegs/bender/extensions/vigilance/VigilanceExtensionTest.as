//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.vigilance
{
	import org.hamcrest.assertThat;
	import org.hamcrest.text.containsString;

	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.bender.framework.impl.Context;

	public class VigilanceExtensionTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var logger:ILogger;

		private var injector:IInjector;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			const context:IContext = new Context().install(VigilanceExtension);
			logger = context.getLogger(this);
			injector = context.injector;
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

		[Test(expects="robotlegs.bender.extensions.vigilance.VigilantError")]
		public function extension_throws_for_WARNING():void
		{
			logger.warn("");
		}

		[Test(expects="robotlegs.bender.extensions.vigilance.VigilantError")]
		public function extension_throws_for_ERROR():void
		{
			logger.error("");
		}

		[Test(expects="robotlegs.bender.extensions.vigilance.VigilantError")]
		public function extension_throws_for_FATAL():void
		{
			logger.fatal("");
		}

		[Test]
		public function extension_throws_when_METADATA_is_missing():void
		{
			const context:IContext = new Context();
			// We can't actually test for missing metadata, so we simulate it.
			context.injector.unmap(IContext);
			var error:VigilantError;
			try
			{
				context.install(VigilanceExtension);
			}
			catch(e:VigilantError)
			{
				error = e;
			}
			assertThat(error.message, containsString("metadata"));
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		// [Test(expects="org.swiftsuspenders.errors.InjectorError")]
		public function extension_throws_for_injector_MAPPING_override():void
		{
			// FlexUnit doesn't seem to be catching this error
			// and instead allows the error to break the test.
			// So commenting this out for now
			// TODO: investigate
			injector.map(String).toValue("string");
			injector.map(String).toValue("string");
		}
	}
}
