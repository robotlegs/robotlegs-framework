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
	import robotlegs.bender.extensions.commandCenter.api.CommandPayload;

	public class CommandPayloadTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var subject:CommandPayload;

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function test_values_by_default_null() : void{
			createConfig();

			assertThat(subject.values, nullValue());
		}

		[Test]
		public function test_classes_by_default_null() : void{
			createConfig();

			assertThat(subject.classes, nullValue());
		}

		[Test]
		public function test_values_are_stored():void
		{
			var expected:Array = ['string', 0];

			createConfig(expected);

			assertThat(subject.values, array(expected));
		}

		[Test]
		public function test_classes_are_stored():void
		{
			var expected:Array = [String, int];

			createConfig(null, expected);

			assertThat(subject.classes, array(expected));
		}

		[Test]
		public function test_adding_stores_values() : void{
			createConfig();

			subject.addPayload( 'string', String);

			var hasValue : Boolean = subject.values.indexOf( 'string' ) > -1;
			assertThat( hasValue, isTrue() );
		}

		[Test]
		public function test_adding_stores_classes() : void{
			createConfig();

			subject.addPayload( 'string', String);

			var hasClass : Boolean = subject.classes.indexOf( String ) > -1;
			assertThat( hasClass, isTrue() );
		}

		[Test]
		public function test_adding_stores_in_lockstep() : void{
			createConfig(['string', 0],[String, int]);
			var value : Object = {};

			subject.addPayload( value, Object );

			var valueIndex : int = subject.values.indexOf( value );
			var classIndex : int = subject.classes.indexOf( Object );
			assertThat(valueIndex,equalTo(classIndex));
		}
		
		[Test]
		public function can_ask_for_length_without_classes():void
		{
		    createConfig();
			assertThat(subject.length, equalTo(0));
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function createConfig(values:Array = null, classes:Array = null):CommandPayload
		{
			return subject = new CommandPayload(values, classes);
		}
	}
}
