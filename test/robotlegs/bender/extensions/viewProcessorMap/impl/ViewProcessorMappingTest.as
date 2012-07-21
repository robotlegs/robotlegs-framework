//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.impl
{
	import flash.display.Sprite;
	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.matching.ITypeFilter;
	import robotlegs.bender.extensions.matching.TypeFilter;
	import robotlegs.bender.extensions.viewProcessorMap.impl.ViewInjectionProcessor;

	public class ViewProcessorMappingTest
	{
		private static const EMPTY_CLASS_VECTOR:Vector.<Class> = new Vector.<Class>();
		private static const MATCHER:ITypeFilter = new TypeFilter(EMPTY_CLASS_VECTOR, EMPTY_CLASS_VECTOR, EMPTY_CLASS_VECTOR);
		
		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/
		
		[Test]
		public function mapping_remembers_matcher():void
		{
			const mapping:ViewProcessorMapping = new ViewProcessorMapping(MATCHER, ViewInjectionProcessor);
			assertThat(mapping.matcher, equalTo(MATCHER));
		}
		
		[Test]
		public function mapping_handed_processor_class_sets_processorClass_property():void
		{
			const processorClass:Class = ViewInjectionProcessor;
			const mapping:ViewProcessorMapping = new ViewProcessorMapping(MATCHER, processorClass);
			assertThat(mapping.processorClass, equalTo(processorClass));
		}
		
		[Test]
		public function mapping_handed_processor_class_leaves_processor_null():void
		{
			const processorClass:Class = ViewInjectionProcessor;
			const mapping:ViewProcessorMapping = new ViewProcessorMapping(MATCHER, processorClass);
			assertThat(mapping.processor, equalTo(null));
		}
		
		[Test]
		public function mapping_handed_processor_object_sets_processorClass_property():void
		{
			const processor:* = new ViewInjectionProcessor();
			const mapping:ViewProcessorMapping = new ViewProcessorMapping(MATCHER, processor);
			assertThat(mapping.processorClass, equalTo(ViewInjectionProcessor));
		}
		
		[Test]
		public function mapping_handed_processor_object_sets_processor_property():void
		{
			const processor:* = new ViewInjectionProcessor();
			const mapping:ViewProcessorMapping = new ViewProcessorMapping(MATCHER, processor);
			assertThat(mapping.processor, equalTo(processor));
		}
	}
}