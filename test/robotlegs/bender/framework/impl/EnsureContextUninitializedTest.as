//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import mockolate.received;
	import mockolate.runner.MockolateRule;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.notNullValue;
	import org.hamcrest.object.nullValue;
	import robotlegs.bender.framework.api.ILogTarget;
	import robotlegs.bender.framework.api.LogLevel;

	public class EnsureContextUninitializedTest
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var logTarget:ILogTarget;

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function warning_logged_unless_context_uninitialized():void
		{
			const context:Context = new Context();
			context.addLogTarget(logTarget);
			context.initialize();
			context.install(SupportExtension);
			assertThat(logTarget, received().method('log')
				.args(instanceOf(SupportExtension),
				LogLevel.WARN,
				notNullValue(),
				"This extension must be installed into an uninitialized context",
				nullValue()).once());

		}
	}
}

import robotlegs.bender.framework.impl.ensureContextUninitialized;
import robotlegs.bender.framework.api.IContext;
import robotlegs.bender.framework.api.IExtension;

class SupportExtension implements IExtension
{

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function extend(context:IContext):void
	{
		ensureContextUninitialized(context, this);
	}
}
