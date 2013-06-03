//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.utils
{
	import org.flexunit.assertThat;
	import org.flexunit.asserts.*;
	import org.hamcrest.object.equalTo;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.impl.RobotlegsInjector;

	public class FastPropertyInjectorTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var instance:FastPropertyInjector;

		private var injector:IInjector;

		private const NUMBER_VALUE:Number = 3;

		private const STRING_VALUE:String = "someValue";

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function setUp():void
		{
			const config:Object = {number: Number, string: String};
			instance = new FastPropertyInjector(config);
			injector = new RobotlegsInjector();
		}

		[After]
		public function tearDown():void
		{
			instance = null;
			injector = null;
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function can_be_instantiated():void
		{
			assertTrue("instance is FastPropertyInjector", instance is FastPropertyInjector);
		}

		[Test]
		public function process_properties_are_injected():void
		{
			injector.map(Number).toValue(NUMBER_VALUE);
			injector.map(String).toValue(STRING_VALUE);

			const view:ViewToBeInjected = new ViewToBeInjected();
			instance.process(view, ViewToBeInjected, injector);

			assertThat(view.number, equalTo(NUMBER_VALUE));
			assertThat(view.string, equalTo(STRING_VALUE));
		}
	}
}

class ViewToBeInjected
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	public var number:Number;

	public var string:String;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	public function ViewToBeInjected()
	{

	}
}
