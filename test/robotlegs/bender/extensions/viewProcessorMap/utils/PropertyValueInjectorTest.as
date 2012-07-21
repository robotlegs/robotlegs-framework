//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.utils 
{
	import org.flexunit.asserts.*;
	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;
	
	public class PropertyValueInjectorTest 
	{
		private var instance:PropertyValueInjector;

		private const NUMBER_VALUE:Number = 3;
		private const STRING_VALUE:String = "someValue";

		[Before]
		public function setUp():void
		{
			const config:Object = {number:NUMBER_VALUE, string:STRING_VALUE};
			instance = new PropertyValueInjector(config);
		}

		[After]
		public function tearDown():void
		{
			instance = null;
		}

		[Test]
		public function can_be_instantiated():void
		{
			assertTrue("instance is PropertyValueInjector", instance is PropertyValueInjector);
		}

		[Test]
		public function process_properties_are_injected():void
		{
			var noInjector:* = null;
			const view:ViewToBeInjected = new ViewToBeInjected();
			instance.process(view, ViewToBeInjected, noInjector);

			assertThat(view.number, equalTo(NUMBER_VALUE));
			assertThat(view.string, equalTo(STRING_VALUE));
		}
	}
}

class ViewToBeInjected
{
	public var number:Number;
	public var string:String;

	public function ViewToBeInjected()
	{

	}
}
