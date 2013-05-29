//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import flash.display.Sprite;
	import mockolate.received;
	import mockolate.runner.MockolateRule;
	import org.hamcrest.assertThat;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.instanceOf;
	import robotlegs.bender.extensions.matching.ITypeFilter;
	import robotlegs.bender.extensions.matching.TypeMatcher;
	import robotlegs.bender.extensions.mediatorMap.support.NullMediator;
	import robotlegs.bender.extensions.mediatorMap.support.NullMediator2;
	import robotlegs.bender.framework.api.ILogger;

	public class MediatorMapperTest
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var handler:MediatorViewHandler;

		[Mock]
		public var logger:ILogger;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var mapper:MediatorMapper;

		private var filter:ITypeFilter;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function setUp():void
		{
			const matcher:TypeMatcher = new TypeMatcher().allOf(Sprite);
			filter = matcher.createTypeFilter();
			mapper = new MediatorMapper(matcher.createTypeFilter(), handler, logger);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function toMediator_registers_mappingConfig_with_handler():void
		{
			const config:Object = mapper.toMediator(NullMediator);
			assertThat(handler, received().method('addMapping').arg(config).once());
		}

		[Test]
		public function fromMediator_unregisters_mappingConfig_from_handler():void
		{
			const oldConfig:Object = mapper.toMediator(NullMediator);
			mapper.fromMediator(NullMediator);
			assertThat(handler, received().method('removeMapping').arg(oldConfig).once());
		}

		[Test]
		public function fromMediator_removes_only_specified_mappingConfig_from_handler():void
		{
			const config1:Object = mapper.toMediator(NullMediator);
			const config2:Object = mapper.toMediator(NullMediator2);
			mapper.fromMediator(NullMediator);
			assertThat(handler, received().method('removeMapping').arg(config1).once());
			assertThat(handler, received().method('removeMapping').arg(config2).never());
		}

		[Test]
		public function fromAll_removes_all_mappingConfigs_from_handler():void
		{
			const config1:Object = mapper.toMediator(NullMediator);
			const config2:Object = mapper.toMediator(NullMediator2);
			mapper.fromAll();
			assertThat(handler, received().method('removeMapping').arg(config1).once());
			assertThat(handler, received().method('removeMapping').arg(config2).once());
		}

		[Test]
		public function toMediator_unregisters_old_mappingConfig_and_registers_new_one_when_overwritten():void
		{
			const oldConfig:Object = mapper.toMediator(NullMediator);
			const newConfig:Object = mapper.toMediator(NullMediator);
			assertThat(handler, received().method('removeMapping').arg(oldConfig).once());
			assertThat(handler, received().method('addMapping').arg(newConfig).once());
		}

		[Test]
		public function toMediator_warns_when_overwritten():void
		{
			const oldConfig:Object = mapper.toMediator(NullMediator);
			mapper.toMediator(NullMediator);
			assertThat(logger, received().method('warn')
				.args(instanceOf(String), array(filter, oldConfig)).once());
		}
	}
}
