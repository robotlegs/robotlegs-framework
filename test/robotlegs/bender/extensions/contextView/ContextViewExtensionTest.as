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

		private var contextView:DisplayObjectContainer;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			context = new Context();
			contextView = new Canvas();
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function contextView_is_mapped_into_injector():void
		{
			var actual:Object = null;
			context.extend(ContextViewExtension).configure(contextView);
			context.lifecycle.whenInitializing(function():void {
				actual = context.injector.getInstance(DisplayObjectContainer);
			});
			context.lifecycle.initialize();
			assertThat(actual, equalTo(contextView));
		}
	}
}
