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
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.notNullValue;
	import robotlegs.bender.extensions.commandCenter.api.ICommandExecutor;
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapper;
	import robotlegs.bender.extensions.commandCenter.api.ICommandMappingList;
	import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;
	import robotlegs.bender.extensions.commandCenter.support.CommandMapStub;

	public class CommandCenterTest
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock(type="strict")]
		public var host:CommandMapStub;

		[Mock]
		public var mapper:ICommandMapper;

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
			new CommandCenter(host.keyFactory, stubby.triggerFactory).getMapper("hi", 5);
		}

		[Test]
		public function triggerFactory_is_called_with_with_params():void
		{
			mock(trigger).getter("executor").returns(executor);
			mock(host).method("triggerFactory").args("hi", 5)
				.returns(trigger).once();
			new CommandCenter(stubby.keyFactory, host.triggerFactory).getMapper("hi", 5);
		}

		[Test]
		public function mapperFactory_is_called_with_with_params():void
		{
			mock(host).method("mapperFactory").args("hi", 5)
				.returns(new DefaultCommandMapper()).once();
			new CommandCenter(stubby.keyFactory, stubby.triggerFactory)
				.withMapperFactory(host.mapperFactory)
				.getMapper("hi", 5);
		}

		[Test]
		public function triggerExecutor_is_given_MappingList():void
		{
			mock(executor).setter("mappings").arg(instanceOf(ICommandMappingList));
			mock(trigger).getter("executor").returns(executor);
			stub(host).method("triggerFactory").returns(trigger);
			new CommandCenter(stubby.keyFactory, host.triggerFactory)
				.getMapper("hi", 5);
			verify(trigger);
		}

		/*[Test]
		public function mappingList_is_given_trigger():void
		{
			stub(host).method("triggerFactory").returns(trigger);
			stub(host).method("mappingListFactory").returns(mappings);
			mock(mappings).setter("trigger").arg(trigger).once();
			new CommandCenter(stubby.keyFactory, host.triggerFactory)
				.withMappingListFactory(host.mappingListFactory)
				.getMapper("hi", 5);
			verify(mappings);
		}

		[Test]
		public function mapper_is_given_mappings_from_factory():void
		{
			stub(host).method("mapperFactory").returns(mapper);
			stub(host).method("mappingListFactory").returns(mappings);
			mock(mapper).setter("mappings").arg(mappings).once();
			new CommandCenter(stubby.keyFactory, stubby.triggerFactory)
				.withMappingListFactory(host.mappingListFactory)
				.withMapperFactory(host.mapperFactory)
				.getMapper("hi", 5);
			verify(mapper);
		}*/

		[Test]
		public function mapper_is_given_default_CommandMappingList():void
		{
			stub(host).method("mapperFactory").returns(mapper);
			mock(mapper).setter("mappings").arg(instanceOf(CommandMappingList)).once();
			new CommandCenter(stubby.keyFactory, stubby.triggerFactory)
				.withMapperFactory(host.mapperFactory)
				.getMapper("hi", 5);
			verify(mapper);
		}

		[Test]
		public function mapper_is_cached_by_key():void
		{
			const subject:CommandCenter = new CommandCenter(stubby.keyFactory, stubby.triggerFactory)
				.withMapperFactory(stubby.mapperFactory);
			const mapper1:Object = subject.getMapper("hi", 5);
			const mapper2:Object = subject.getMapper("hi", 5);
			assertThat(mapper1, notNullValue());
			assertThat(mapper1, equalTo(mapper2));
		}

		[Test]
		public function removeMapper_deactivates_trigger():void
		{
			stub(trigger).getter("executor").returns(executor);
			stub(host).method("triggerFactory").returns(trigger);
			mock(trigger).method("deactivate").once();
			const subject:CommandCenter = new CommandCenter(stubby.keyFactory, host.triggerFactory);
			subject.getMapper("hi", 5);
			subject.removeMapper("hi", 5);
			verify(trigger);
		}

		[Test]
		public function unmap_non_existent_mapping_returns_NullCommandUnmapper():void
		{
			const subject:CommandCenter = new CommandCenter(stubby.keyFactory, stubby.triggerFactory);
			assertThat(subject.getUnmapper("hi", 5), instanceOf(NullCommandUnmapper))
		}

		[Test]
		public function unmap_non_existent_mapping_uses_provided_nullCommandUnmapper():void
		{
			const unmapper:NullCommandUnmapper = new NullCommandUnmapper();
			const subject:CommandCenter = new CommandCenter(stubby.keyFactory, stubby.triggerFactory)
					.withNullCommandUnmapper(unmapper);
			assertThat(subject.getUnmapper("hi", 5), equalTo(unmapper));
		}

		[Test]
		public function unmap_returns_unmapper():void
		{
			mapper = new DefaultCommandMapper();
			stub(host).method("mapperFactory").returns(mapper);
			const subject:CommandCenter = new CommandCenter(stubby.keyFactory, stubby.triggerFactory)
				.withMapperFactory(host.mapperFactory);
			assertThat(subject.getMapper("hi", 5), equalTo(mapper));
			assertThat(subject.getUnmapper("hi", 5), equalTo(mapper));
		}

	}
}
