//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;

	import robotlegs.bender.extensions.commandCenter.support.NullCommand;

	public class CommandMappingTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var mapping:CommandMapping;

		private var commandClass:Class;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			commandClass = NullCommand;
			mapping = new CommandMapping(commandClass);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function mapping_stores_Command():void
		{
			assertThat(mapping.commandClass, equalTo(commandClass));
		}

		[Test]
		public function default_ExecuteMethod():void
		{
			assertThat(mapping.executeMethod, equalTo("execute"));
		}

		[Test]
		public function mapping_stores_ExecuteMethod():void
		{
			mapping.setExecuteMethod("run");
			assertThat(mapping.executeMethod, equalTo("run"));
		}

		[Test]
		public function mapping_stores_Guards():void
		{
			mapping.addGuards(1, 2, 3);
			assertThat(mapping.guards, array(1, 2, 3));
		}

		[Test]
		public function mapping_stores_GuardsArray():void
		{
			mapping.addGuards([1, 2, 3]);
			assertThat(mapping.guards, array(1, 2, 3));
		}

		[Test]
		public function mapping_stores_Hooks():void
		{
			mapping.addHooks(1, 2, 3);
			assertThat(mapping.hooks, array(1, 2, 3));
		}

		[Test]
		public function mapping_stores_HooksArray():void
		{
			mapping.addHooks([1, 2, 3]);
			assertThat(mapping.hooks, array(1, 2, 3));
		}

		[Test]
		public function fireOnce_defaults_to_False():void
		{
			assertThat(mapping.fireOnce, isFalse());
		}

		[Test]
		public function mapping_stores_FireOnce():void
		{
			mapping.setFireOnce(true);
			assertThat(mapping.fireOnce, isTrue());
		}

		[Test]
		public function mapping_stores_FireOnce_when_false():void
		{
			mapping.setFireOnce(false);
			assertThat(mapping.fireOnce, isFalse());
		}

		[Test]
		public function payloadInjectionEnabled_defaults_to_True():void
		{
			assertThat(mapping.payloadInjectionEnabled, isTrue());
		}

		[Test]
		public function mapping_stores_PayloadInjectionEnabled():void
		{
		    mapping.setPayloadInjectionEnabled(false);
			assertThat(mapping.payloadInjectionEnabled, isFalse());
		}
	}
}
