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
	import org.swiftsuspenders.Injector;

	public class FastPropertyInjectorTest 
	{
		private var instance:FastPropertyInjector;
		
		private var injector:Injector;
		
		private const NUMBER_VALUE:Number = 3;
		private const STRING_VALUE:String = "someValue";

		[Before]
		public function setUp():void
		{
			const config:Object = {number:Number, string:String};
			instance = new FastPropertyInjector(config);
			injector = new Injector();
		}

		[After]
		public function tearDown():void
		{
			instance = null;
			injector = null;
		}

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
	public var number:Number;
	public var string:String;
	
	public function ViewToBeInjected()
	{
		
	}
}