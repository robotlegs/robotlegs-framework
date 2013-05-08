//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.swiftsuspenders.Injector;

	public class GetRootInjectorTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var rootInjector:Injector;

		private var childInjector:Injector;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			rootInjector = new Injector();
			childInjector = rootInjector.createChildInjector();
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function retrieves_the_root_injector():void
		{
			var actual : Injector = getRootInjector(childInjector);
			assertThat(actual, equalTo(rootInjector));
		}
	}
}
