//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.lifecycle
{
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;

	public class LifecycleTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var target:Object;

		private var lifecycle:Lifecycle;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			target = new Object();
			lifecycle = new Lifecycle(target);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function lifecycle_starts_uninitialized():void
		{
			assertThat(lifecycle.state, equalTo(LifecycleState.UNINITIALIZED));
		}

		[Test]
		public function target_is_correct():void
		{
			assertThat(lifecycle.target, equalTo(target));
		}
	}
}
