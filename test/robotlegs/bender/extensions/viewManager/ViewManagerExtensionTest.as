//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager
{
	import org.flexunit.assertThat;
	import org.hamcrest.object.instanceOf;
	import robotlegs.bender.extensions.viewManager.api.IViewManager;
	import robotlegs.bender.framework.impl.Context;

	public class ViewManagerExtensionTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var context:Context;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			context = new Context();
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test(expects="robotlegs.bender.framework.api.LifecycleError")]
		public function installing_after_initialization_throws_error():void
		{
			context.initialize();
			context.install(ViewManagerExtension);
		}

		[Test]
		public function viewManager_is_mapped_into_injector():void
		{
			var actual:Object = null;
			context.install(ViewManagerExtension);
			context.whenInitializing(function():void {
				actual = context.injector.getInstance(IViewManager);
			});
			context.initialize();
			assertThat(actual, instanceOf(IViewManager));
		}
	}
}
