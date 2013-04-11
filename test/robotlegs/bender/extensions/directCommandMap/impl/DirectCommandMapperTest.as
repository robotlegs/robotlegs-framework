//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.directCommandMap.impl
{
	import mockolate.capture;
	import mockolate.ingredients.Capture;
	import mockolate.mock;
	import mockolate.runner.MockolateRule;
	import mockolate.stub;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.core.not;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import org.hamcrest.object.nullValue;
	import robotlegs.bender.extensions.commandCenter.api.ICommandExecutor;
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
	import robotlegs.bender.extensions.commandCenter.api.ICommandMappingList;
	import robotlegs.bender.extensions.commandCenter.support.ClassReportingCallbackHook;
	import robotlegs.bender.extensions.commandCenter.support.NullCommand;
	import robotlegs.bender.extensions.commandCenter.support.NullCommand2;
	import robotlegs.bender.extensions.directCommandMap.dsl.IDirectCommandConfigurator;
	import robotlegs.bender.framework.impl.guardSupport.GrumpyGuard;
	import robotlegs.bender.framework.impl.guardSupport.HappyGuard;

	public class DirectCommandMapperTest
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var executor:ICommandExecutor;

		[Mock]
		public var mappings:ICommandMappingList;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var subject:DirectCommandMapper;

		private var capturedMapping:Capture;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			capturedMapping = new Capture();
			stub(mappings).method('addMapping').args(capture(capturedMapping));
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function registers_new_commandMapping_with_CommandMappingList():void
		{

			createMapper(NullCommand);

			assertThat(getCapturedMapping(), instanceOf(ICommandMapping));
		}

		[Test]
		public function mapping_is_fireOnce_by_default():void
		{

			createMapper(NullCommand);

			assertThat(getCapturedMapping().fireOnce, isTrue());
		}

		[Test]
		public function withExecuteMethod_sets_executeMethod_of_mapping():void
		{
			var executeMethod:String = 'otherThanExecute';

			createMapper(NullCommand).withExecuteMethod(executeMethod);

			assertThat(getCapturedMapping().executeMethod, equalTo(executeMethod));
		}

		[Test]
		public function withGuards_sets_guards_of_mapping():void
		{
			var expected:Array = [HappyGuard, GrumpyGuard];

			createMapper(NullCommand).withGuards.apply(null, expected);

			assertThat(getCapturedMapping().guards, array(expected));
		}

		[Test]
		public function withHooks_sets_hooks_of_mapping():void
		{
			var expected:Array = [ClassReportingCallbackHook, ClassReportingCallbackHook];

			createMapper(NullCommand).withHooks.apply(null, expected);

			assertThat(getCapturedMapping().hooks, array(expected));
		}

		[Test]
		public function withPayloadInjection_sets_payloadInjection_of_mapping():void
		{

			createMapper(NullCommand).withPayloadInjection(false);

			assertThat(getCapturedMapping().payloadInjectionEnabled, isFalse());
		}

		[Test]
		public function calls_executor_executeCommands_with_arguments():void
		{

			var actual:Array;
			var list:Vector.<ICommandMapping> = new Vector.<ICommandMapping>();
			stub(mappings).method('getList').returns(list);
			mock(executor).method('executeCommands').callsWithArguments(function(... params):void {
				actual = params;
			});

			createMapper(NullCommand).execute(null);

			assertThat(actual, array(list, nullValue()));
		}

		[Test]
		public function map_creates_new_mapper_instance():void
		{

			var newMapper:IDirectCommandConfigurator = createMapper(NullCommand).map(NullCommand2);

			assertThat(newMapper, not(nullValue()));
			assertThat(newMapper, not(equalTo(subject)));
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function createMapper(commandClass:Class):DirectCommandMapper
		{
			subject = new DirectCommandMapper(executor, mappings, commandClass);
			return subject;
		}

		private function getCapturedMapping():ICommandMapping
		{
			return capturedMapping.value as ICommandMapping
		}
	}
}
