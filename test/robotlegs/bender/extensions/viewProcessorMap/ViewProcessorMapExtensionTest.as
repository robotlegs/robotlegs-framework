//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap
{
	import org.flexunit.assertThat;
	import org.flexunit.asserts.*;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import robotlegs.bender.extensions.viewProcessorMap.api.IViewProcessorMap;
	import robotlegs.bender.extensions.viewManager.ViewManagerExtension;
	import robotlegs.bender.framework.impl.Context;

	public class ViewProcessorMapExtensionTest
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
			context.install(ViewProcessorMapExtension);
		}

		[Test]
		public function viewProcessorMap_is_mapped_into_injector_on_initialize():void
		{
			var actual:Object = null;
			context.install(ViewManagerExtension, ViewProcessorMapExtension);
			context.whenInitializing( function():void {
				actual = context.injector.getInstance(IViewProcessorMap);
			});
			context.initialize();
			assertThat(actual, instanceOf(IViewProcessorMap));
		}
		
		[Test]
		public function viewProcessorMap_is_unmapped_from_injector_on_destroy():void
		{
			context.install(ViewManagerExtension, ViewProcessorMapExtension);
			context.afterDestroying( function():void {
				assertFalse(context.injector.satisfiesDirectly(IViewProcessorMap));
			});
			context.initialize();
			context.destroy();
		}
	}
}
