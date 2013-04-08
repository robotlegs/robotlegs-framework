//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isTrue;
	import org.hamcrest.object.nullValue;

	public class CommandPayloadConfigTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var subject:CommandPayloadConfig;

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function test_values_by_default_null() : void{
			createConfig();

			assertThat(subject.payloadValues, nullValue());
		}

		[Test]
		public function test_classes_by_default_null() : void{
			createConfig();

			assertThat(subject.payloadClasses, nullValue());
		}

		[Test]
		public function test_values_are_stored():void
		{
			var expected:Array = ['string', 0];

			createConfig(expected);

			assertThat(subject.payloadValues, array(expected));
		}

		[Test]
		public function test_classes_are_stored():void
		{
			var expected:Array = [String, int];

			createConfig(null, expected);

			assertThat(subject.payloadClasses, array(expected));
		}

		[Test]
		public function test_adding_stores_values() : void{
			createConfig();

			subject.addPayload( 'string', String);

			var hasValue : Boolean = subject.payloadValues.indexOf( 'string' ) > -1;
			assertThat( hasValue, isTrue() );
		}

		[Test]
		public function test_adding_stores_classes() : void{
			createConfig();

			subject.addPayload( 'string', String);

			var hasClass : Boolean = subject.payloadClasses.indexOf( String ) > -1;
			assertThat( hasClass, isTrue() );
		}

		[Test]
		public function test_adding_stores_in_lockstep() : void{
			createConfig(['string', 0],[String, int]);
			var value : Object = {};

			subject.addPayload( value, Object );

			var valueIndex : int = subject.payloadValues.indexOf( value );
			var classIndex : int = subject.payloadClasses.indexOf( Object );
			assertThat(valueIndex,equalTo(classIndex));
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function createConfig(values:Array = null, classes:Array = null):CommandPayloadConfig
		{
			return subject = new CommandPayloadConfig(values, classes);
		}
	}
}
