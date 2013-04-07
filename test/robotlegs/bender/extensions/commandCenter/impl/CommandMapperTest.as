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
	import org.hamcrest.assertThat;
	import org.hamcrest.object.instanceOf;

	import robotlegs.bender.extensions.commandCenter.dsl.ICommandConfigurator;
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
	import robotlegs.bender.extensions.commandCenter.api.ICommandMappingList;

	public class CommandMapperTest
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var mappings:ICommandMappingList;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var subject:CommandMapper;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			subject = new CommandMapper(mappings);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function toCommand_creates_ICommandConfigurator():void
		{
			assertThat(subject.toCommand(String), instanceOf(ICommandConfigurator))
		}

		[Test]
		public function toCommand_passes_CommandMapping_to_MappingList():void
		{
			mock(mappings).method("addMapping").args(instanceOf(ICommandMapping)).once();
			subject.toCommand(String);
		}

		[Test]
		public function fromCommand_delegates_to_MappingList():void
		{
			mock(mappings).method("removeMappingFor").once();
			subject.fromCommand(String);
		}

		[Test]
		public function fromAll_delegates_to_MappingList():void
		{
			mock(mappings).method("removeAllMappings").once();
			subject.fromAll();
		}
	}
}
