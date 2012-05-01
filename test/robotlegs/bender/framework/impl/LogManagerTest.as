//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import org.flexunit.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import robotlegs.bender.framework.api.ILogger;
	import robotlegs.bender.framework.api.LogLevel;
	import robotlegs.bender.framework.impl.LogManager;
	import robotlegs.bender.framework.impl.loggingSupport.CallbackLogTarget;

	public class LogManagerTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var source:Object;

		private var logManager:LogManager;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			source = {};
			logManager = new LogManager();
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function level_is_set():void
		{
			logManager.logLevel = LogLevel.WARN;
			assertThat(logManager.logLevel, equalTo(LogLevel.WARN));
		}

		[Test]
		public function get_logger():void
		{
			assertThat(logManager.getLogger(source), instanceOf(ILogger));
		}

		[Test]
		public function added_targets_are_logged_to():void
		{
			const expected:Array = ['target1', 'target2', 'target3'];
			var actual:Array = [];
			logManager.addLogTarget(new CallbackLogTarget(function(result:Object):void {
				actual.push('target1');
			}));
			logManager.addLogTarget(new CallbackLogTarget(function(result:Object):void {
				actual.push('target2');
			}));
			logManager.addLogTarget(new CallbackLogTarget(function(result:Object):void {
				actual.push('target3');
			}));
			logManager.getLogger(source).info(expected);
			assertThat(actual, array(expected));
		}
	}
}
