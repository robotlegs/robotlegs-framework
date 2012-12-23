//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap
{
	import org.flexunit.assertThat;
	import org.flexunit.asserts.*;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
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
				assertFalse(context.injector.hasMapping(IMediatorMap));
			});
			context.initialize();
			context.destroy();
		}
	}
}
