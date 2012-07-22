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
		
		[Test(expects="robotlegs.bender.framework.api.MappingConfigError")]
		public function different_guard_mapping_throws_mapping_error():void
		{
			mapping.withGuards(GuardA, GuardB);
			mapping.invalidate();
			mapping.withGuards(GuardA, GuardC);
		}
		
		[Test(expects="robotlegs.bender.framework.api.MappingConfigError")]
		public function different_hook_mapping_throws_mapping_error():void
		{
			mapping.withHooks(HookA, HookC);
			mapping.invalidate();
			mapping.withHooks(HookB);
		}
		
		[Test]
		public function consistent_hook_mapping_doesnt_throw_error():void
		{
			mapping.withHooks(HookA, HookC);
			mapping.invalidate();
			mapping.withHooks(HookA);
		}
		
		[Test]
		public function consistent_guard_mapping_doesnt_throw_error():void
		{
			mapping.withGuards(GuardA, GuardB);
			mapping.invalidate();
			mapping.withGuards(GuardA);
		}
		
		[Test(expects="robotlegs.bender.extensions.commandCenter.api.CommandMappingError")]
		public function changing_once_after_lock_throws_error():void
		{
			mapping.invalidate();
			mapping.once();
		}
		
		[Test(expects="robotlegs.bender.framework.api.MappingConfigError")]
		public function consistent_guard_mapping_with_ommission_throws_when_commandClass_retrieved():void
		{
			mapping.withGuards(GuardA, GuardB);
			mapping.invalidate();
			mapping.withGuards(GuardA);
			mapping.validate();
		}
		
		[Test(expects="robotlegs.bender.framework.api.MappingConfigError")]
		public function consistent_hook_mapping_with_ommission_throws_when_commandClass_retrieved():void
		{
			mapping.withGuards(HookA, HookB);
			mapping.invalidate();
			mapping.withGuards(HookB);
			mapping.validate();
		}
	}
}


class GuardA
{
	public function approve():Boolean
	{
		return true;
	}
}

class GuardB
{
	public function approve():Boolean
	{
		return true;
	}
}

class GuardC
{
	public function approve():Boolean
	{
		return true;
	}
}

class HookA
{
	public function hook():void
	{
	}
}

class HookB
{
	public function hook():void
	{
	}
}

class HookC
{
	public function hook():void
	{
	}
}