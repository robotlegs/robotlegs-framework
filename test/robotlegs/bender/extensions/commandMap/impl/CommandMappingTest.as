//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandMap.impl
{
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;

	import robotlegs.bender.extensions.commandMap.support.NullCommand;

	public class CommandMappingTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var mapping:CommandMapping;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			mapping = new CommandMapping(NullCommand);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function mapping_stores_Command():void
		{
			assertThat(mapping.commandClass, equalTo(NullCommand));
		}

		[Test]
		public function mapping_stores_Guards():void
		{
			mapping.withGuards(1, 2, 3);
			assertThat(mapping.guards, array(1, 2, 3));
		}

		[Test]
		public function mapping_stores_GuardsArray():void
		{
			mapping.withGuards([1, 2, 3]);
			assertThat(mapping.guards, array(1, 2, 3));
		}

		[Test]
		public function mapping_stores_Hooks():void
		{
			mapping.withHooks(1, 2, 3);
			assertThat(mapping.hooks, array(1, 2, 3));
		}

		[Test]
		public function mapping_stores_HooksArray():void
		{
			mapping.withHooks([1, 2, 3]);
			assertThat(mapping.hooks, array(1, 2, 3));
		}

		[Test]
		public function mapping_stores_FireOnce():void
		{
			mapping.once();
			assertThat(mapping.fireOnce, isTrue());
		}

		[Test]
		public function mapping_stores_FireOnce_when_false():void
		{
			mapping.once(false);
			assertThat(mapping.fireOnce, isFalse());
		}
	}
}
