//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.contextView
{
	import flash.display.DisplayObjectContainer;
	import mx.containers.Canvas;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isTrue;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.LogLevel;
	import robotlegs.bender.framework.impl.Context;
	import robotlegs.bender.framework.impl.loggingSupport.CallbackLogTarget;

	public class ContextViewExtensionTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var context:IContext;

		private var view:DisplayObjectContainer;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			context = new Context();
			view = new Canvas();
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test(expects="robotlegs.bender.framework.api.LifecycleError")]
		public function installing_after_initialization_throws_error():void
		{
			context.initialize();
			context.install(ContextViewExtension);
		}

		[Test]
		public function contextView_is_mapped():void
		{
			var actual:ContextView = null;
			context.install(ContextViewExtension).configure(new ContextView(view));
			context.whenInitializing(function():void {
				actual = context.injector.getInstance(ContextView);
			});
			context.initialize();
			assertThat(actual.view, equalTo(view));
		}

		[Test]
		public function second_displayObjectContainer_is_ignored():void
		{
			var actual:ContextView = null;
			const secondView:DisplayObjectContainer = new Canvas();
			context.install(ContextViewExtension).configure(new ContextView(view), new ContextView(secondView));
			context.whenInitializing(function():void {
				actual = context.injector.getInstance(ContextView);
			});
			context.initialize();
			assertThat(actual.view, equalTo(view));
		}

		[Test]
		public function extension_logs_error_when_context_initialized_with_no_contextView():void
		{
			var errorLogged:Boolean = false;
			const logTarget:CallbackLogTarget = new CallbackLogTarget(
				function(log:Object):void {
					if (log.source['constructor'] == ContextViewExtension && log.level == LogLevel.ERROR)
					{
						errorLogged = true;
					}
				});
			context.install(ContextViewExtension);
			context.addLogTarget(logTarget);
			context.initialize();
			assertThat(errorLogged, isTrue());
		}
	}
}
