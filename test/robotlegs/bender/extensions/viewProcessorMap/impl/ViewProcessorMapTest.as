//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.impl
{
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import mx.core.UIComponent;
	import org.flexunit.assertThat;
	import org.flexunit.async.Async;
	import org.fluint.uiImpersonation.UIImpersonator;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.isFalse;
	import robotlegs.bender.extensions.matching.TypeMatcher;
	import robotlegs.bender.extensions.viewManager.api.IViewHandler;
	import robotlegs.bender.extensions.viewProcessorMap.support.Processor;
	import robotlegs.bender.extensions.viewProcessorMap.support.TrackingProcessor;
	import robotlegs.bender.extensions.viewProcessorMap.support.TrackingProcessor2;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.impl.RobotlegsInjector;

	public class ViewProcessorMapTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		// TODO: extract processing tests into own tests
		// TODO: add actual ViewProcessorMap tests

		private const spriteMatcher:TypeMatcher = new TypeMatcher().allOf(Sprite);

		private var viewProcessorMap:ViewProcessorMap;

		private var trackingProcessor:TrackingProcessor;

		private var trackingProcessor2:TrackingProcessor;

		private var injector:IInjector;

		private var matchingView:Sprite;

		private var nonMatchingView:Shape;

		private var container:UIComponent;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			container = new UIComponent();
			injector = new RobotlegsInjector();
			injector.map(RobotlegsInjector).toValue(injector);
			viewProcessorMap = new ViewProcessorMap(new ViewProcessorFactory(injector));
			trackingProcessor = new TrackingProcessor();
			trackingProcessor2 = new TrackingProcessor();
			matchingView = new Sprite();
			nonMatchingView = new Shape();
			UIImpersonator.addChild(container);
		}

		[After]
		public function after():void
		{
			UIImpersonator.removeChild(container);
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
			assertThatProcessorHasProcessedThese(trackingProcessor, [matchingView]);
		}

		[Test]
		public function process_passes_mapped_views_to_processor_instance_process_with_mapping_by_matcher():void
		{
			viewProcessorMap.mapMatcher(spriteMatcher).toProcess(trackingProcessor);
			viewProcessorMap.process(matchingView);
			viewProcessorMap.process(nonMatchingView);
			assertThatProcessorHasProcessedThese(trackingProcessor, [matchingView]);
		}

		[Test]
		public function process_passes_mapped_views_to_processor_class_process_with_mapping_by_type():void
		{
			viewProcessorMap.map(Sprite).toProcess(TrackingProcessor);
			viewProcessorMap.process(matchingView);
			viewProcessorMap.process(nonMatchingView);
			assertThatProcessorHasProcessedThese(fromInjector(TrackingProcessor), [matchingView]);
		}

		[Test]
		public function process_passes_mapped_views_to_processor_class_process_with_mapping_by_matcher():void
		{
			viewProcessorMap.mapMatcher(spriteMatcher).toProcess(TrackingProcessor);
			viewProcessorMap.process(matchingView);
			viewProcessorMap.process(nonMatchingView);
			assertThatProcessorHasProcessedThese(fromInjector(TrackingProcessor), [matchingView]);
		}

		[Test]
		public function mapping_one_matcher_to_multiple_processes_by_class_all_processes_run():void
		{
			viewProcessorMap.mapMatcher(spriteMatcher).toProcess(TrackingProcessor);
			viewProcessorMap.mapMatcher(spriteMatcher).toProcess(TrackingProcessor2);
			viewProcessorMap.process(matchingView);
			viewProcessorMap.process(nonMatchingView);
			assertThatProcessorHasProcessedThese(fromInjector(TrackingProcessor), [matchingView]);
			assertThatProcessorHasProcessedThese(fromInjector(TrackingProcessor2), [matchingView]);
		}

		[Test]
		public function mapping_one_matcher_to_multiple_processes_by_instance_all_processes_run():void
		{
			viewProcessorMap.mapMatcher(spriteMatcher).toProcess(trackingProcessor);
			viewProcessorMap.mapMatcher(spriteMatcher).toProcess(trackingProcessor2);
			viewProcessorMap.process(matchingView);
			viewProcessorMap.process(nonMatchingView);
			assertThatProcessorHasProcessedThese(trackingProcessor, [matchingView]);
			assertThatProcessorHasProcessedThese(trackingProcessor2, [matchingView]);
		}

		[Test]
		public function duplicate_identical_mappings_by_class_do_not_repeat_processes():void
		{
			viewProcessorMap.mapMatcher(spriteMatcher).toProcess(TrackingProcessor);
			viewProcessorMap.mapMatcher(spriteMatcher).toProcess(TrackingProcessor);
			viewProcessorMap.process(matchingView);
			viewProcessorMap.process(nonMatchingView);
			assertThatProcessorHasProcessedThese(fromInjector(TrackingProcessor), [matchingView]);
		}

		[Test]
		public function duplicate_identical_mappings_by_instance_do_not_repeat_processes():void
		{
			viewProcessorMap.mapMatcher(spriteMatcher).toProcess(trackingProcessor);
			viewProcessorMap.mapMatcher(spriteMatcher).toProcess(trackingProcessor);
			viewProcessorMap.process(matchingView);
			viewProcessorMap.process(nonMatchingView);
			assertThatProcessorHasProcessedThese(trackingProcessor, [matchingView]);
		}

		[Test]
		public function unprocess_passes_mapped_views_to_processor_instance_unprocess_with_mapping_by_type():void
		{
			viewProcessorMap.map(Sprite).toProcess(trackingProcessor);
			viewProcessorMap.unprocess(matchingView);
			viewProcessorMap.unprocess(nonMatchingView);
			assertThatProcessorHasUnprocessedThese(trackingProcessor, [matchingView]);
		}

		[Test]
		public function unprocess_passes_mapped_views_to_processor_instance_unprocess_with_mapping_by_matcher():void
		{
			viewProcessorMap.mapMatcher(spriteMatcher).toProcess(trackingProcessor);
			viewProcessorMap.unprocess(matchingView);
			viewProcessorMap.unprocess(nonMatchingView);
			assertThatProcessorHasUnprocessedThese(trackingProcessor, [matchingView]);
		}

		[Test]
		public function unmapping_matcher_from_single_processor_stops_further_processing():void
		{
			viewProcessorMap.mapMatcher(spriteMatcher).toProcess(trackingProcessor);
			viewProcessorMap.process(matchingView);
			viewProcessorMap.unmapMatcher(spriteMatcher).fromProcess(trackingProcessor);
			viewProcessorMap.process(matchingView);
			assertThatProcessorHasProcessedThese(trackingProcessor, [matchingView]);
		}

		[Test]
		public function unmapping_type_from_single_processor_stops_further_processing():void
		{
			viewProcessorMap.map(Sprite).toProcess(trackingProcessor);
			viewProcessorMap.process(matchingView);
			viewProcessorMap.unmap(Sprite).fromProcess(trackingProcessor);
			viewProcessorMap.process(matchingView);
			assertThatProcessorHasProcessedThese(trackingProcessor, [matchingView]);
		}

		[Test]
		public function unmapping_from_single_processor_keeps_other_processors_intact():void
		{
			viewProcessorMap.map(Sprite).toProcess(trackingProcessor);
			viewProcessorMap.map(Sprite).toProcess(trackingProcessor2);
			viewProcessorMap.unmap(Sprite).fromProcess(trackingProcessor);
			viewProcessorMap.process(matchingView);
			assertThatProcessorHasProcessedThese(trackingProcessor, []);
			assertThatProcessorHasProcessedThese(trackingProcessor2, [matchingView]);
		}

		[Test]
		public function unmapping_from_all_processes_removes_all_processes():void
		{
			viewProcessorMap.map(Sprite).toProcess(TrackingProcessor);
			viewProcessorMap.map(Sprite).toProcess(trackingProcessor2);
			viewProcessorMap.unmap(Sprite).fromAll();
			viewProcessorMap.process(matchingView);
			assertThatProcessorHasProcessedThese(fromInjector(TrackingProcessor), []);
			assertThatProcessorHasProcessedThese(trackingProcessor2, []);
		}

		[Test]
		public function handleItem_passes_mapped_views_to_processor_instance_process_with_mapping_by_type():void
		{
			viewProcessorMap.map(Sprite).toProcess(trackingProcessor);
			viewProcessorMap.handleView(matchingView, Sprite);
			viewProcessorMap.handleView(nonMatchingView, Shape);
			assertThatProcessorHasProcessedThese(trackingProcessor, [matchingView]);
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
		public function does_not_leave_view_mapping_lying_around():void
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
			assertThatProcessorHasProcessedThese(trackingProcessor, [matchingView]);
		}

		[Test]
		public function process_does_not_run_if_guard_prevents_it():void
		{
			viewProcessorMap.map(Sprite).toProcess(trackingProcessor).withGuards(OnlyIfViewHasChildrenGuard);
			viewProcessorMap.process(matchingView);
			assertThatProcessorHasProcessedThese(trackingProcessor, []);
		}

		[Test]
		public function removing_a_mapping_that_does_not_exist_does_not_throw_an_error():void
		{
			viewProcessorMap.unmap(Sprite).fromProcess(trackingProcessor);
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
			var asyncHandler:Function = Async.asyncHandler(this, checkUnprocessorsRan, 500);
			matchingView.addEventListener(Event.REMOVED_FROM_STAGE, asyncHandler);
			container.removeChild(matchingView);
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

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		protected function fromInjector(type:Class):Object
		{
			if (!injector.hasDirectMapping(type))
			{
				injector.map(type).asSingleton();
			}
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

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function checkUnprocessorsRan(e:Event, params:Object):void
		{
			assertThatProcessorHasUnprocessedThese(trackingProcessor, [matchingView]);
		}
	}
}

import flash.display.Sprite;
import flash.events.IEventDispatcher;

class ViewNeedingInjection extends Sprite
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var injectedValue:IEventDispatcher;
}

class OnlyIfViewHasChildrenGuard
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var view:Sprite;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function approve():Boolean
	{
		return (view.numChildren > 0);
	}
}

class HookWithViewInjectionDrawsRectangle
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var view:Sprite;

	[Inject(name="rectWidth")]
	public var rectWidth:Number;

	[Inject(name="rectHeight")]
	public var rectHeight:Number;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function hook():void
	{
		view.graphics.drawRect(0, 0, rectWidth, rectHeight);
	}
}

class HookA
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject(name='timingTracker')]
	public var timingTracker:Array;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function hook():void
	{
		timingTracker.push(HookA);
	}
}
