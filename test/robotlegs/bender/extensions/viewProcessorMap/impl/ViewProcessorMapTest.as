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
	import org.flexunit.async.Async;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.isFalse;
	import org.swiftsuspenders.Injector;
	import flash.display.Shape;
	import robotlegs.bender.extensions.viewProcessorMap.support.TrackingProcessor;
	import robotlegs.bender.extensions.matching.TypeMatcher;
	import robotlegs.bender.extensions.viewProcessorMap.support.TrackingProcessor2;
	import robotlegs.bender.extensions.viewManager.api.IViewHandler;
	import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorMappingConfig;
	import robotlegs.bender.framework.impl.guardSupport.HappyGuard;
	import robotlegs.bender.extensions.viewProcessorMap.impl.ViewProcessorMapping;
	import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorMapping;
	import flash.events.IEventDispatcher;
	import flash.events.Event;
	import org.fluint.uiImpersonation.UIImpersonator;
	import mx.core.UIComponent;
	
	public class ViewProcessorMapTest
	{
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var viewProcessorMap:ViewProcessorMap;
		private var trackingProcessor:TrackingProcessor;
		private var trackingProcessor2:TrackingProcessor;
		private var injector:Injector;
		private const spriteMatcher:TypeMatcher = new TypeMatcher().allOf(Sprite);
		private var matchingView:Sprite;
		private var nonMatchingView:Shape;
		private var factory:ViewProcessorFactory;
		private var container:UIComponent;
		
		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			injector = new Injector();
			injector.map(Injector).toValue(injector);
			factory = new ViewProcessorFactory(injector);
			viewProcessorMap = new ViewProcessorMap(factory);
			trackingProcessor = new TrackingProcessor();
			trackingProcessor2 = new TrackingProcessor();
			matchingView = new Sprite();
			nonMatchingView = new Shape();
			container = new UIComponent();
			UIImpersonator.addChild(container);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/
		
		[Test]
		public function implements_IViewHandler():void
		{
			assertThat(viewProcessorMap, instanceOf(IViewHandler));
		}
		
		[Test]
		public function process_passes_mapped_views_to_processor_instance_process_with_mapping_by_type():void
		{
			viewProcessorMap.map(Sprite).toProcess(trackingProcessor);
			viewProcessorMap.process(matchingView);
			viewProcessorMap.process(nonMatchingView);
			assertThatProcessorHasProcessedThese( trackingProcessor, [matchingView] );
		}
		
		[Test]
		public function process_passes_mapped_views_to_processor_instance_process_with_mapping_by_matcher():void
		{
			viewProcessorMap.mapMatcher(spriteMatcher).toProcess(trackingProcessor);
			viewProcessorMap.process(matchingView);
			viewProcessorMap.process(nonMatchingView);
			assertThatProcessorHasProcessedThese( trackingProcessor, [matchingView] );
		}
		
		[Test]
		public function process_passes_mapped_views_to_processor_class_process_with_mapping_by_type():void
		{
			viewProcessorMap.map(Sprite).toProcess(TrackingProcessor);
			viewProcessorMap.process(matchingView);
			viewProcessorMap.process(nonMatchingView);
			assertThatProcessorHasProcessedThese( fromInjector(TrackingProcessor), [matchingView]);
		}
		
		[Test]
		public function process_passes_mapped_views_to_processor_class_process_with_mapping_by_matcher():void
		{
			viewProcessorMap.mapMatcher(spriteMatcher).toProcess(TrackingProcessor);
			viewProcessorMap.process(matchingView);
			viewProcessorMap.process(nonMatchingView);
			assertThatProcessorHasProcessedThese( fromInjector(TrackingProcessor), [matchingView] );
		}
		
		[Test]
		public function mapping_one_matcher_to_multiple_processes_by_class_all_processes_run():void
		{
			viewProcessorMap.mapMatcher(spriteMatcher).toProcess(TrackingProcessor);
			viewProcessorMap.mapMatcher(spriteMatcher).toProcess(TrackingProcessor2);
			viewProcessorMap.process(matchingView);
			viewProcessorMap.process(nonMatchingView);
			assertThatProcessorHasProcessedThese( fromInjector(TrackingProcessor), [matchingView] );
			assertThatProcessorHasProcessedThese( fromInjector(TrackingProcessor2), [matchingView] );
		}
		
		[Test]
		public function mapping_one_matcher_to_multiple_processes_by_instance_all_processes_run():void
		{
			viewProcessorMap.mapMatcher(spriteMatcher).toProcess(trackingProcessor);
			viewProcessorMap.mapMatcher(spriteMatcher).toProcess(trackingProcessor2);
			viewProcessorMap.process(matchingView);
			viewProcessorMap.process(nonMatchingView);
			assertThatProcessorHasProcessedThese( trackingProcessor, [matchingView] );
			assertThatProcessorHasProcessedThese( trackingProcessor2, [matchingView] );
		}
		
		[Test]
		public function duplicate_identical_mappings_by_class_dont_repeat_processes():void
		{
			viewProcessorMap.mapMatcher(spriteMatcher).toProcess(TrackingProcessor);
			viewProcessorMap.mapMatcher(spriteMatcher).toProcess(TrackingProcessor);
			viewProcessorMap.process(matchingView);
			viewProcessorMap.process(nonMatchingView);
			assertThatProcessorHasProcessedThese( fromInjector(TrackingProcessor), [matchingView] );
		}
		
		[Test]
		public function duplicate_identical_mappings_by_instance_dont_repeat_processes():void
		{
			viewProcessorMap.mapMatcher(spriteMatcher).toProcess(trackingProcessor);
			viewProcessorMap.mapMatcher(spriteMatcher).toProcess(trackingProcessor);
			viewProcessorMap.process(matchingView);
			viewProcessorMap.process(nonMatchingView);
			assertThatProcessorHasProcessedThese( trackingProcessor, [matchingView] );
		}
		
		[Test]
		public function unprocess_passes_mapped_views_to_processor_instance_unprocess_with_mapping_by_type():void
		{
			viewProcessorMap.map(Sprite).toProcess(trackingProcessor);
			viewProcessorMap.unprocess(matchingView);
			viewProcessorMap.unprocess(nonMatchingView);
			assertThatProcessorHasUnprocessedThese( trackingProcessor, [matchingView] );
		}
		
		[Test]
		public function unprocess_passes_mapped_views_to_processor_instance_unprocess_with_mapping_by_matcher():void
		{
			viewProcessorMap.mapMatcher(spriteMatcher).toProcess(trackingProcessor);
			viewProcessorMap.unprocess(matchingView);
			viewProcessorMap.unprocess(nonMatchingView);
			assertThatProcessorHasUnprocessedThese( trackingProcessor, [matchingView] );
		}
		
		[Test]
		public function unmapping_matcher_from_single_processor_stops_further_processing():void
		{
			viewProcessorMap.mapMatcher(spriteMatcher).toProcess(trackingProcessor);
			viewProcessorMap.process(matchingView);
			viewProcessorMap.unmapMatcher(spriteMatcher).fromProcess(trackingProcessor);
			viewProcessorMap.process(matchingView);
			assertThatProcessorHasProcessedThese( trackingProcessor, [matchingView] );
		}
		
		[Test]
		public function unmapping_type_from_single_processor_stops_further_processing():void
		{
			viewProcessorMap.map(Sprite).toProcess(trackingProcessor);
			viewProcessorMap.process(matchingView);
			viewProcessorMap.unmap(Sprite).fromProcess(trackingProcessor);
			viewProcessorMap.process(matchingView);
			assertThatProcessorHasProcessedThese( trackingProcessor, [matchingView] );
		}
		
		[Test]
		public function unmapping_from_single_processor_keeps_other_processors_intact():void
		{
			viewProcessorMap.map(Sprite).toProcess(trackingProcessor);
			viewProcessorMap.map(Sprite).toProcess(trackingProcessor2);
			viewProcessorMap.unmap(Sprite).fromProcess(trackingProcessor);
			viewProcessorMap.process(matchingView);
			assertThatProcessorHasProcessedThese( trackingProcessor, [] );
			assertThatProcessorHasProcessedThese( trackingProcessor2, [matchingView] );
		}
		
		[Test]
		public function unmapping_from_all_processes_removes_all_processes():void
		{
			viewProcessorMap.map(Sprite).toProcess(TrackingProcessor);
			viewProcessorMap.map(Sprite).toProcess(trackingProcessor2);
			viewProcessorMap.unmap(Sprite).fromProcesses();
			viewProcessorMap.process(matchingView);
			assertThatProcessorHasProcessedThese( fromInjector(TrackingProcessor), [] );
			assertThatProcessorHasProcessedThese( trackingProcessor2, [] );
		}
		
		[Test]
		public function handleItem_passes_mapped_views_to_processor_instance_process_with_mapping_by_type():void
		{
			viewProcessorMap.map(Sprite).toProcess(trackingProcessor);
			viewProcessorMap.handleView(matchingView, Sprite);
			viewProcessorMap.handleView(nonMatchingView, Shape);
			assertThatProcessorHasProcessedThese( trackingProcessor, [matchingView] );
		}
		
		[Test]
		public function a_hook_runs_and_receives_injection_of_view():void
		{
			viewProcessorMap.map(Sprite).toProcess(trackingProcessor).withHooks(HookWithViewInjectionDrawsRectangle);

			const expectedViewWidth:Number = 100;
			const expectedViewHeight:Number = 200;

			injector.map(Number, 'rectHeight').toValue(expectedViewHeight);
			injector.map(Number, 'rectWidth').toValue(expectedViewWidth);

			viewProcessorMap.process(matchingView);

			assertThat(matchingView.width, equalTo(expectedViewWidth));
			assertThat(matchingView.height, equalTo(expectedViewHeight));
		}
		
		[Test]
		public function doesnt_leave_view_mapping_lying_around():void
		{
			viewProcessorMap.map(Sprite).toProcess(trackingProcessor);
			viewProcessorMap.handleView(matchingView, Sprite);
			assertThat(injector.hasMapping(Sprite), isFalse());
		}
		
		[Test]
		public function process_runs_if_guard_allows_it():void
		{
			viewProcessorMap.map(Sprite).toProcess(trackingProcessor).withGuards(OnlyIfViewHasChildrenGuard);
			matchingView.addChild(new Sprite());
			viewProcessorMap.process(matchingView);
			assertThatProcessorHasProcessedThese( trackingProcessor, [matchingView] );
		}

		[Test]
		public function process_does_not_run_if_guard_prevents_it():void
		{
			viewProcessorMap.map(Sprite).toProcess(trackingProcessor).withGuards(OnlyIfViewHasChildrenGuard);
			viewProcessorMap.process(matchingView);
			assertThatProcessorHasProcessedThese( trackingProcessor, [] );
		}
		
		[Test]
		public function removing_a_mapping_that_doesnt_exist_doesnt_throw_an_error():void
		{
			viewProcessorMap.unmap(Sprite).fromProcess(trackingProcessor);
		}
		
		[Test(expects="robotlegs.bender.extensions.viewProcessorMap.api.ViewProcessorMappingError")]
		public function error_thrown_if_2_mappings_made_with_same_matcher_and_processor_but_different_guards():void
		{
			viewProcessorMap.map(Sprite).toProcess(TrackingProcessor).withGuards(HappyGuard).withHooks(Alpha50PercentHook);
			viewProcessorMap.map(Sprite).toProcess(TrackingProcessor).withGuards(OnlyIfViewHasChildrenGuard).withHooks(Alpha50PercentHook);			
		}
		
		[Test(expects="robotlegs.bender.extensions.viewProcessorMap.api.ViewProcessorMappingError")]
		public function error_thrown_if_2_mappings_made_with_same_matcher_and_processor_but_different_hooks():void
		{
			viewProcessorMap.map(Sprite).toProcess(TrackingProcessor).withGuards(HappyGuard).withHooks(Alpha50PercentHook);
			viewProcessorMap.map(Sprite).toProcess(TrackingProcessor).withGuards(HappyGuard).withHooks(HookWithViewInjectionDrawsRectangle);
		}
		
		[Test(expects="robotlegs.bender.extensions.viewProcessorMap.api.ViewProcessorMappingError")]
		public function error_thrown_if_2_mappings_made_with_same_matcher_and_processor_one_with_one_without_guards():void
		{
			viewProcessorMap.map(Sprite).toProcess(TrackingProcessor).withGuards(HappyGuard);
			const mapping:IViewProcessorMapping = viewProcessorMap.map(Sprite).toProcess(TrackingProcessor) as IViewProcessorMapping;
			// error only thrown when used sadly			
			mapping.matcher;			
		}
		
		[Test(expects="robotlegs.bender.extensions.viewProcessorMap.api.ViewProcessorMappingError")]
		public function error_thrown_if_2_mappings_made_with_same_matcher_and_processor_one_with_one_without_hooks():void
		{
			viewProcessorMap.map(Sprite).toProcess(TrackingProcessor).withHooks(Alpha50PercentHook);
			const mapping:IViewProcessorMapping = viewProcessorMap.map(Sprite).toProcess(TrackingProcessor) as IViewProcessorMapping;
			// error only thrown when used sadly			
			mapping.matcher;			
		}

		[Test]
		public function no_error_thrown_when_guards_and_hooks_are_chained():void
		{
			const mappingConfig:IViewProcessorMappingConfig = viewProcessorMap.map(Sprite).toProcess(TrackingProcessor);
			mappingConfig.withGuards(HappyGuard);
			mappingConfig.withGuards(OnlyIfViewHasChildrenGuard);
			mappingConfig.withHooks(Alpha50PercentHook);
			mappingConfig.withHooks(HookWithViewInjectionDrawsRectangle);
		}
		
		[Test(expects="robotlegs.bender.extensions.viewProcessorMap.api.ViewProcessorMappingError")]
		public function error_thrown_if_2_mappings_made_with_same_matcher_and_processor_one_with_fewer_guards():void
		{
			viewProcessorMap.map(Sprite).toProcess(TrackingProcessor).withGuards(HappyGuard, OnlyIfViewHasChildrenGuard);
			const mapping:ViewProcessorMapping = viewProcessorMap.map(Sprite).toProcess(TrackingProcessor) as ViewProcessorMapping;
			mapping.withGuards(HappyGuard);
			// error only thrown when used sadly			
			mapping.matcher;			
		}
		
		[Test(expects="robotlegs.bender.extensions.viewProcessorMap.api.ViewProcessorMappingError")]
		public function error_thrown_if_2_mappings_made_with_same_matcher_and_processor_one_with_fewer_hooks():void
		{
			viewProcessorMap.map(Sprite).toProcess(TrackingProcessor).withHooks(Alpha50PercentHook).withHooks(HookA);
			const mapping:ViewProcessorMapping = viewProcessorMap.map(Sprite).toProcess(TrackingProcessor) as ViewProcessorMapping;
			mapping.withHooks(HookA);
			// error only thrown when used sadly			
			mapping.matcher;			
		}
		
		[Test]
		public function no_error_thrown_when_2_mappings_with_identical_guards_and_hooks_are_chained():void
		{
			const mapping1:ViewProcessorMapping = viewProcessorMap.map(Sprite).toProcess(TrackingProcessor) as ViewProcessorMapping;
			mapping1.withGuards(HappyGuard);
			mapping1.withGuards(OnlyIfViewHasChildrenGuard);
			mapping1.withHooks(Alpha50PercentHook);
			mapping1.withHooks(HookWithViewInjectionDrawsRectangle);
			
			const mapping2:ViewProcessorMapping = viewProcessorMap.map(Sprite).toProcess(TrackingProcessor) as ViewProcessorMapping;
			mapping2.withGuards(HappyGuard);
			mapping2.withGuards(OnlyIfViewHasChildrenGuard);
			mapping2.withHooks(HookWithViewInjectionDrawsRectangle);
			mapping2.withHooks(Alpha50PercentHook);

			mapping2.matcher;
		}
		
		[Test]
		public function mapping_guards_and_hooks_as_array_is_same_as_mapping_as_list():void
		{
			const mapping1:ViewProcessorMapping = viewProcessorMap.map(Sprite).toProcess(TrackingProcessor) as ViewProcessorMapping;
			mapping1.withGuards(HappyGuard, OnlyIfViewHasChildrenGuard);
			mapping1.withHooks(Alpha50PercentHook, HookA);
			
			const mapping2:ViewProcessorMapping = viewProcessorMap.map(Sprite).toProcess(TrackingProcessor) as ViewProcessorMapping;
			mapping2.withGuards([HappyGuard, OnlyIfViewHasChildrenGuard]);
			mapping2.withHooks([Alpha50PercentHook, HookA]);
			
			mapping2.matcher;
		}
		
		[Test]
		public function mapping_for_injection_results_in_view_being_injected():void
		{
			const expectedInjectionValue:Sprite = new Sprite();
			
			injector.map(IEventDispatcher).toValue(expectedInjectionValue);
			
			viewProcessorMap.map(Sprite).toInjection();
			const viewNeedingInjection:ViewNeedingInjection = new ViewNeedingInjection();
			viewProcessorMap.process(viewNeedingInjection);
			assertThat(viewNeedingInjection.injectedValue, equalTo(expectedInjectionValue));
		}
		
		[Test]
		public function unmapping_for_injection_results_in_view_not_being_injected():void
		{
			viewProcessorMap.map(Sprite).toInjection();
			viewProcessorMap.unmap(Sprite).fromInjection();
			const viewNeedingInjection:ViewNeedingInjection = new ViewNeedingInjection();
			viewProcessorMap.process(viewNeedingInjection);
			assertThat(viewNeedingInjection.injectedValue, equalTo(null));
		}
		
		[Test]
		public function mapping_to_no_process_still_applies_hooks():void
		{
			viewProcessorMap.map(Sprite).toNoProcess().withHooks(HookWithViewInjectionDrawsRectangle);

			const expectedViewWidth:Number = 100;
			const expectedViewHeight:Number = 200;

			injector.map(Number, 'rectHeight').toValue(expectedViewHeight);
			injector.map(Number, 'rectWidth').toValue(expectedViewWidth);

			viewProcessorMap.process(matchingView);

			assertThat(matchingView.width, equalTo(expectedViewWidth));
			assertThat(matchingView.height, equalTo(expectedViewHeight));			
		}
		
		[Test]
		public function unmapping_from_no_process_does_not_apply_hooks():void
		{
			viewProcessorMap.map(Sprite).toNoProcess().withHooks(HookWithViewInjectionDrawsRectangle);

			injector.map(Number, 'rectHeight').toValue(100);
			injector.map(Number, 'rectWidth').toValue(200);

			viewProcessorMap.unmap(Sprite).fromNoProcess();
			viewProcessorMap.process(matchingView);

			assertThat(matchingView.width, equalTo(0));
			assertThat(matchingView.height, equalTo(0));			
		}
		
		[Test(async)]
		public function automatically_unprocesses_when_view_leaves_stage():void
		{
			viewProcessorMap.map(Sprite).toProcess(trackingProcessor);
			container.addChild(matchingView);
			viewProcessorMap.process(matchingView);
			var asyncHandler:Function = Async.asyncHandler( this, checkUnprocessorsRan, 500 );
			matchingView.addEventListener(Event.REMOVED_FROM_STAGE, asyncHandler);
			container.removeChild(matchingView);
		}
	
		private function checkUnprocessorsRan(e:Event, params:Object):void
		{
			assertThatProcessorHasUnprocessedThese(trackingProcessor, [matchingView]);
		}
		
		[Test]
		public function hooks_run_before_process():void
		{
			const timingTracker:Array = [];
			injector.map(Array, 'timingTracker').toValue(timingTracker);
			viewProcessorMap.map(Sprite).toProcess(Processor).withHooks(HookA);
			viewProcessorMap.process(matchingView);
			assertThat(timingTracker, array([HookA, Processor]));
		}
		
		
		// protected functions
		
		protected function fromInjector(type:Class):Object
		{
			return injector.getInstance(type);
		}
		
		protected function assertThatProcessorHasProcessedThese(processor:Object, expected:Array):void
		{
			assertThat(processor.processedViews, array(expected));
		}

		protected function assertThatProcessorHasUnprocessedThese(processor:Object, expected:Array):void
		{
			assertThat(processor.unprocessedViews, array(expected));
		}

	}
}

import flash.display.Sprite;
import flash.events.IEventDispatcher;

class ViewNeedingInjection extends Sprite
{
	[Inject]
	public var injectedValue:IEventDispatcher;
}

class OnlyIfViewHasChildrenGuard
{
	[Inject]
	public var view:Sprite;

	public function approve():Boolean
	{
		return (view.numChildren > 0);
	}
}

class HookWithViewInjectionDrawsRectangle
{
	[Inject]
	public var view:Sprite;

	[Inject(name="rectWidth")]
	public var rectWidth:Number;
	
	[Inject(name="rectHeight")]
	public var rectHeight:Number;
	
	public function hook():void
	{
		view.graphics.drawRect(0, 0, rectWidth, rectHeight);
	}
}

class Alpha50PercentHook
{
	[Inject]
	public var view:Sprite;
	
	public function hook():void
	{
		view.alpha = 0.5;
	}
}

class HookA
{
	[Inject(name='timingTracker')]
	public var timingTracker:Array;
	
	public function hook():void
	{
		timingTracker.push(HookA);
	}
}

class Processor
{
	[Inject(name='timingTracker')]
	public var timingTracker:Array;
	
	public function process(view:*, type:Class, injector:*):void
	{
		timingTracker.push(Processor);
	}
	
	public function unprocess(view:*, type:Class, injector:*):void
	{
		
	}
}