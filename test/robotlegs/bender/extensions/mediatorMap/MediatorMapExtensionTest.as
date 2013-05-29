//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.isFalse;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMap;
	import robotlegs.bender.extensions.viewManager.ViewManagerExtension;
	import robotlegs.bender.framework.impl.Context;

	public class MediatorMapExtensionTest
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
			context.install(MediatorMapExtension);
		}

		[Test]
		public function mediatorMap_is_mapped_into_injector_on_initialize():void
		{
			var actual:Object = null;
			context.install(ViewManagerExtension, MediatorMapExtension);
			context.whenInitializing( function():void {
				actual = context.injector.getInstance(IMediatorMap);
			});
			context.initialize();
			assertThat(actual, instanceOf(IMediatorMap));
		}
		
		[Test]
		public function mediatorMap_is_unmapped_from_injector_on_destroy():void
		{
			context.install(ViewManagerExtension, MediatorMapExtension);
			context.afterDestroying( function():void {
				assertThat(context.injector.hasMapping(IMediatorMap), isFalse());
			});
			context.initialize();
			context.destroy();
		}
	}
}
