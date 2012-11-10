//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.contextView
{
	import flash.display.DisplayObjectContainer;
	import mx.containers.Canvas;
	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.impl.Context;

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

		[Test]
		public function contextView_is_mapped():void
		{
			var actual:ContextView = null;
			context.install(ContextViewExtension).configure(new ContextView(view));
			context.lifecycle.whenInitializing(function():void {
				actual = context.injector.getInstance(ContextView);
			});
			context.lifecycle.initialize();
			assertThat(actual.view, equalTo(view));
		}

		[Test]
		public function second_displayObjectContainer_is_ignored():void
		{
			var actual:ContextView = null;
			const secondView:DisplayObjectContainer = new Canvas();
			context.install(ContextViewExtension).configure(new ContextView(view), new ContextView(secondView));
			context.lifecycle.whenInitializing(function():void {
				actual = context.injector.getInstance(ContextView);
			});
			context.lifecycle.initialize();
			assertThat(actual.view, equalTo(view));
		}

		[Test(expects="Error")]
		public function extension_throws_if_context_initialized_with_no_contextView():void
		{
			context.install(ContextViewExtension);
			context.lifecycle.initialize();
		}
	}
}
