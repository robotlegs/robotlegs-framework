//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.core.impl
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextLogTarget;
	import org.robotlegs.v2.core.api.IContextLogger;
	import org.robotlegs.v2.core.impl.support.CallbackLogTarget;
	import org.robotlegs.v2.core.impl.support.NullContext;

	public class ContextLoggerTests
	{

		[Before]
		public function setUp():void
		{
		}

		[After]
		public function tearDown():void
		{
		}

		[Test]
		public function context_is_logged():void
		{
			const context:IContext = new NullContext();
			const info:LogInfo = new LogInfo();
			const logger:IContextLogger = context.logger;
			logger.addTarget(createReportingTarget(info));
			logger.debug(this, 'any');
			assertThat(info.context, equalTo(context));
		}

		[Test]
		public function source_is_logged():void
		{
			const source:Object = {};
			const info:LogInfo = new LogInfo();
			const logger:IContextLogger = new ContextLogger(null);
			logger.addTarget(createReportingTarget(info));
			logger.debug(source, 'any');
			assertThat(info.source, equalTo(source));
		}

		[Test]
		public function message_is_logged():void
		{
			const message:String = 'hello';
			const info:LogInfo = new LogInfo();
			const logger:IContextLogger = createReportingLogger(info);
			logger.debug(this, message);
			assertThat(info.message, equalTo(message));
		}

		[Test]
		public function parameters_are_logged():void
		{
			const parameters:Array = [0, 1];
			const info:LogInfo = new LogInfo();
			const logger:IContextLogger = createReportingLogger(info);
			logger.debug(this, '', parameters);
			assertThat(info.parameters, equalTo(parameters));
		}

		[Test]
		public function logger_does_not_throw_error_when_it_has_no_targets():void
		{
			const logger:IContextLogger = new ContextLogger(null);
			logger.debug(this, 'debug');
			logger.info(this, 'info');
			logger.warn(this, 'warn');
			logger.error(this, 'error');
			logger.fatal(this, 'fatal');
		}

		private function createReportingLogger(info:LogInfo, level:uint = 32):IContextLogger
		{
			const logger:IContextLogger = new ContextLogger(null);
			const target:IContextLogTarget = createReportingTarget(info, level);
			logger.addTarget(target);
			return logger;
		}

		private function createReportingTarget(info:LogInfo, level:uint = 32):IContextLogTarget
		{
			return new CallbackLogTarget(
				level,
				function(context:IContext, source:Object, level:uint, timestamp:int, message:*, parameters:Array = null):void
				{
					info.timesCalled++;
					info.context = context;
					info.source = source;
					info.level = level;
					info.timestamp = timestamp;
					info.message = message;
					info.parameters = parameters;
				});
		}
	}
}

import org.robotlegs.v2.core.api.IContext;

class LogInfo
{
	public var timesCalled:uint;

	public var context:IContext;

	public var source:Object;

	public var level:uint;

	public var timestamp:int;

	public var message:*;

	public var parameters:Array;
}
