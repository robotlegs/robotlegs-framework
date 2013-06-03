//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.impl
{
	import flash.display.Sprite;
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEqualsArraysIgnoringOrder;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.isTrue;
	import robotlegs.bender.extensions.matching.TypeMatcher;
	import robotlegs.bender.extensions.viewProcessorMap.support.ITrackingProcessor;
	import robotlegs.bender.extensions.viewProcessorMap.support.TrackingProcessor;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.impl.RobotlegsInjector;

	public class ViewProcessorFactoryTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var viewProcessorFactory:ViewProcessorFactory;

		private var trackingProcessor:TrackingProcessor;

		private var injector:IInjector;

		private var view:Sprite;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			injector = new RobotlegsInjector();
			viewProcessorFactory = new ViewProcessorFactory(injector);
			trackingProcessor = new TrackingProcessor();
			view = new Sprite();
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function runProcessOnExistingProcessor():void
		{
			const mappings:Array = [];
			mappings.push(new ViewProcessorMapping(new TypeMatcher().allOf(Sprite).createTypeFilter(), trackingProcessor));

			viewProcessorFactory.runProcessors(view, Sprite, mappings);
			assertThat(trackingProcessor.processedViews, array([view]));
		}

		[Test]
		public function runProcessOnMultipleProcessors():void
		{
			const mappings:Array = [];
			mappings.push(new ViewProcessorMapping(new TypeMatcher().allOf(Sprite).createTypeFilter(), trackingProcessor));

			const trackingProcessor2:TrackingProcessor = new TrackingProcessor();
			mappings.push(new ViewProcessorMapping(new TypeMatcher().allOf(Sprite).createTypeFilter(), trackingProcessor2));

			viewProcessorFactory.runProcessors(view, Sprite, mappings);
			assertThat(trackingProcessor.processedViews, array([view]));
			assertThat(trackingProcessor2.processedViews, array([view]));
		}

		[Test]
		public function runUnprocessOnExistingProcessor():void
		{
			const mappings:Array = [];
			mappings.push(new ViewProcessorMapping(new TypeMatcher().allOf(Sprite).createTypeFilter(), trackingProcessor));

			viewProcessorFactory.runProcessors(view, Sprite, mappings);
			viewProcessorFactory.runUnprocessors(view, Sprite, mappings);
			assertThat(trackingProcessor.unprocessedViews, array([view]));
		}

		[Test]
		public function runUnprocessOnMultipleProcessors():void
		{
			const mappings:Array = [];
			mappings.push(new ViewProcessorMapping(new TypeMatcher().allOf(Sprite).createTypeFilter(), trackingProcessor));

			const trackingProcessor2:TrackingProcessor = new TrackingProcessor();
			mappings.push(new ViewProcessorMapping(new TypeMatcher().allOf(Sprite).createTypeFilter(), trackingProcessor2));

			viewProcessorFactory.runProcessors(view, Sprite, mappings);
			viewProcessorFactory.runUnprocessors(view, Sprite, mappings);
			assertThat(trackingProcessor.processedViews, array([view]));
			assertThat(trackingProcessor2.processedViews, array([view]));
		}

		[Test]
		public function getsProcessorFromInjectorWhereMapped():void
		{
			const mappings:Array = [];
			mappings.push(new ViewProcessorMapping(new TypeMatcher().allOf(Sprite).createTypeFilter(), TrackingProcessor));

			injector.map(TrackingProcessor).toValue(trackingProcessor);

			viewProcessorFactory.runProcessors(view, Sprite, mappings);
			assertThat(trackingProcessor.processedViews, array([view]));
		}

		[Test]
		public function createsProcessorSingletonMappingWhereNotMappedAndRunsProcess():void
		{
			const mappings:Array = [];
			mappings.push(new ViewProcessorMapping(new TypeMatcher().allOf(Sprite).createTypeFilter(), TrackingProcessor));

			viewProcessorFactory.runProcessors(view, Sprite, mappings);
			const createdTrackingProcessor:TrackingProcessor = injector.getInstance(TrackingProcessor);
			assertThat(createdTrackingProcessor.processedViews, array([view]));
		}

		[Test]
		public function createsProcessorSingletonMappingWhereNotMapped():void
		{
			const mappings:Array = [];
			mappings.push(new ViewProcessorMapping(new TypeMatcher().allOf(Sprite).createTypeFilter(), TrackingProcessor));

			viewProcessorFactory.runProcessors(view, Sprite, mappings);
			assertThat(injector.hasDirectMapping(TrackingProcessor), isTrue());
		}

		[Test(expects='robotlegs.bender.extensions.viewProcessorMap.api.ViewProcessorMapError')]
		public function requestingAnUnmappedInterfaceThrowsInformativeError():void
		{
			const mappings:Array = [];
			mappings.push(new ViewProcessorMapping(new TypeMatcher().allOf(Sprite).createTypeFilter(), ITrackingProcessor));

			viewProcessorFactory.runProcessors(view, Sprite, mappings);
		}

		[Test]
		public function runAllUnprocessors_runs_all_unprocessors_for_all_views():void
		{
			const trackingProcessor2:TrackingProcessor = new TrackingProcessor();

			const mapping:ViewProcessorMapping = new ViewProcessorMapping(new TypeMatcher().allOf(Sprite).createTypeFilter(), trackingProcessor);
			const mappingA:ViewProcessorMapping = new ViewProcessorMapping(new TypeMatcher().allOf(SpriteA).createTypeFilter(), trackingProcessor2);

			const viewA:SpriteA = new SpriteA();

			viewProcessorFactory.runProcessors(view, Sprite, [mapping]);
			viewProcessorFactory.runProcessors(viewA, SpriteA, [mapping, mappingA]);

			viewProcessorFactory.runAllUnprocessors();

			assertEqualsArraysIgnoringOrder('trackingProcessor unprocessed all views', trackingProcessor.unprocessedViews, [view, viewA]);
			assertEqualsArraysIgnoringOrder('trackingProcessor2 unprocessed all views', trackingProcessor2.unprocessedViews, [viewA]);
		}
	}
}

import flash.display.Sprite;

class SpriteA extends Sprite
{
}
