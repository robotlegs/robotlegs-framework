//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.impl
{
	import mockolate.received;
	import mockolate.runner.MockolateRule;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.instanceOf;
	import robotlegs.bender.extensions.viewProcessorMap.support.NullProcessor2;
	import robotlegs.bender.framework.api.ILogger;

	public class ViewProcessorMapperTest
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var handler:IViewProcessorViewHandler;

		[Mock]
		public var logger:ILogger;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var mapper:ViewProcessorMapper;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			mapper = new ViewProcessorMapper(null, handler, logger);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function toProcess_registers_mappingConfig_with_handler():void
		{
			const mapping:Object = mapper.toProcess(NullProcessor);
			assertThat(handler, received().method('addMapping').arg(mapping).once());
		}

		[Test]
		public function fromProcess_removes_mappingConfig_from_handler():void
		{
			const mapping:Object = mapper.toProcess(NullProcessor);
			mapper.fromProcess(NullProcessor);
			assertThat(handler, received().method('removeMapping').arg(mapping).once());
		}

		[Test]
		public function fromProcess_removes_only_specified_mappingConfig_from_handler():void
		{
			const mapping:Object = mapper.toProcess(NullProcessor);
			const mapping2:Object = mapper.toProcess(NullProcessor2);
			mapper.fromProcess(NullProcessor);
			assertThat(handler, received().method('removeMapping').arg(mapping).once());
			assertThat(handler, received().method('removeMapping').arg(mapping2).never());
		}

		[Test]
		public function fromAll_removes_all_mappingConfigs_from_handler():void
		{
			const mapping:Object = mapper.toProcess(NullProcessor);
			const mapping2:Object = mapper.toProcess(NullProcessor2);
			mapper.fromAll();
			assertThat(handler, received().method('removeMapping').arg(mapping).once());
			assertThat(handler, received().method('removeMapping').arg(mapping2).once());
		}

		[Test]
		public function toProcess_unregisters_old_mappingConfig_and_registers_new_one_when_overwritten():void
		{
			const oldMapping:Object = mapper.toProcess(NullProcessor);
			const newMapping:Object = mapper.toProcess(NullProcessor);
			assertThat(handler, received().method('removeMapping').arg(oldMapping).once());
			assertThat(handler, received().method('addMapping').arg(newMapping).once());
		}

		[Test]
		public function toProcess_warns_when_overwritten():void
		{
			const oldMapping:Object = mapper.toProcess(NullProcessor);
			mapper.toProcess(NullProcessor);
			assertThat(logger, received().method('warn')
				.args(instanceOf(String), array(null, oldMapping)).once());
		}
	}
}
