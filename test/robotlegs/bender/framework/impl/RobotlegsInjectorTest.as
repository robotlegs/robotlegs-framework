//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import flash.system.ApplicationDomain;

	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import robotlegs.bender.framework.api.IInjector;

	public class RobotlegsInjectorTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var injector:RobotlegsInjector;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			injector = new RobotlegsInjector();
		}

		[After]
		public function after():void
		{
			injector = null;
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function parent_get_set():void
		{
			const expected:IInjector = new RobotlegsInjector();
			injector.parent = expected;
			assertThat(injector.parent, equalTo(expected));
		}

		[Test]
		public function createChild_remembers_parent():void
		{
			const child:IInjector = injector.createChild();
			assertThat(child.parent, equalTo(injector));
		}

		[Test]
		public function createChild_uses_provided_ApplicationDomain():void
		{
			const expected:ApplicationDomain = new ApplicationDomain();
			const child:IInjector = injector.createChild(expected);
			assertThat(child.applicationDomain, equalTo(expected));
		}

		[Test]
		public function createChild_inherits_ApplicationDomain():void
		{
			const child:IInjector = injector.createChild();
			assertThat(child.applicationDomain, equalTo(injector.applicationDomain));
		}
	}
}
