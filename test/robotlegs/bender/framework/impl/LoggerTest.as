//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import org.flexunit.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import robotlegs.bender.framework.api.LogLevel;
	import robotlegs.bender.framework.impl.Logger;
	import robotlegs.bender.framework.impl.loggingSupport.CallbackLogTarget;

	public class LoggerTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var source:Object;

		private var logger:Logger;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			source = {};
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function source_is_passed():void
		{
			const expected:Object = source;
			var actual:Object = null;
			logger = new Logger(source, new CallbackLogTarget(function(result:Object):void {
				actual = result.source;
			}));
			logger.debug("hello");
			assertThat(actual, equalTo(expected));
		}

		[Test]
		public function level_is_passed():void
		{
			const expected:Array = [LogLevel.FATAL, LogLevel.ERROR, LogLevel.WARN, LogLevel.INFO, LogLevel.DEBUG];
			var actual:Array = [];
			logger = new Logger(source, new CallbackLogTarget(function(result:Object):void {
				actual.push(result.level);
			}));
			logger.fatal("fatal");
			logger.error("error");
			logger.warn("warn");
			logger.info("info");
			logger.debug("debug");
			assertThat(actual, array(expected));
		}

		[Test]
		public function message_is_passed():void
		{
			const expected:String = "hello";
			var actual:String = null;
			logger = new Logger(source, new CallbackLogTarget(function(result:Object):void {
				actual = result.message;
			}));
			logger.debug(expected);
			assertThat(actual, equalTo(expected));
		}

		[Test]
		public function params_are_passed():void
		{
			const expected:Array = [1, 2, 3];
			var actual:Array = null;
			logger = new Logger(source, new CallbackLogTarget(function(result:Object):void {
				actual = result.params;
			}));
			logger.debug("hello", expected);
			assertThat(actual, equalTo(expected));
		}
	}
}

