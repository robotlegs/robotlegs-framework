//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.displayList
{
	import flash.display.DisplayObjectContainer;
	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.context.impl.Context;
	import robotlegs.bender.framework.object.managed.impl.ManagedObject;
	import spark.components.Group;

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
			contextView = new Group();
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function contextView_is_mapped_into_injector():void
		{
			var actual:DisplayObjectContainer;
			context.require(
				ContextViewExtension,
				contextView);
			context.addStateHandler(ManagedObject.SELF_INITIALIZE, function():void {
				actual = context.injector.getInstance(DisplayObjectContainer);
			});
			context.initialize();
			assertThat(actual, equalTo(contextView));
		}
	}
}
