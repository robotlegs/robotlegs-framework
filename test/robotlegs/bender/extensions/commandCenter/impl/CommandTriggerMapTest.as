//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{
	import mockolate.mock;
	import mockolate.runner.MockolateRule;
	import mockolate.stub;
	import mockolate.verify;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.notNullValue;
	import robotlegs.bender.extensions.commandCenter.api.ICommandExecutor;
	import robotlegs.bender.extensions.commandCenter.api.ICommandMappingList;
	import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
	import robotlegs.bender.extensions.commandCenter.support.CommandMapStub;

	public class CommandTriggerMapTest
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock(type="strict")]
		public var host:CommandMapStub;

		[Mock]
		public var trigger:ICommandTrigger;

		[Mock]
		public var executor:ICommandExecutor;

		[Mock]
		public var mappings:ICommandMappingList;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var stubby:CommandMapStub;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			stubby = new CommandMapStub();
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function keyFactory_is_called_with_params():void
		{
			mock(host).method("keyFactory").args("hi", 5)
				.returns("anyKey").once();
			new CommandTriggerMap(host.keyFactory, stubby.triggerFactory).getTrigger("hi", 5);
		}

		[Test]
		public function triggerFactory_is_called_with_with_params():void
		{
			mock(host).method("triggerFactory").args("hi", 5)
				.returns(trigger).once();
			new CommandTriggerMap(stubby.keyFactory, host.triggerFactory).getTrigger("hi", 5);
		}

		[Test]
		public function trigger_is_cached_by_key():void
		{
			const subject:CommandTriggerMap = new CommandTriggerMap(stubby.keyFactory, stubby.triggerFactory);
			const mapper1:Object = subject.getTrigger("hi", 5);
			const mapper2:Object = subject.getTrigger("hi", 5);
			assertThat(mapper1, notNullValue());
			assertThat(mapper1, equalTo(mapper2));
		}

		[Test]
		public function removeTrigger_deactivates_trigger():void
		{
			stub(host).method("triggerFactory").returns(trigger);
			mock(trigger).method("deactivate").once();
			const subject:CommandTriggerMap = new CommandTriggerMap(stubby.keyFactory, host.triggerFactory);
			subject.getTrigger("hi", 5);
			subject.removeTrigger("hi", 5);
			verify(trigger);
		}

	}
}
