//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.impl
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import mx.core.UIComponent;
	import org.flexunit.async.Async;
	import org.flexunit.asserts.assertEqualsVectorsIgnoringOrder;
	import org.fluint.uiImpersonation.UIImpersonator;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import robotlegs.bender.extensions.matching.TypeMatcher;
	import robotlegs.bender.extensions.mediatorMap.impl.support.MediatorWatcher;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.viewProcessorMap.utils.MediatorCreator;

	public class ViewProcessorMediatorsTest
	{
		private var injector:Injector;

		private var instance:ViewProcessorMap;
		
		private var mediatorWatcher:MediatorWatcher;
		
		private var matchingView:Sprite;

		private var container:UIComponent;
		
		[Before(async, ui)]
		public function setUp():void
		{
			container = new UIComponent();

			injector = new Injector();
			instance = new ViewProcessorMap(new ViewProcessorFactory(injector));

			mediatorWatcher = new MediatorWatcher();
			injector.map(MediatorWatcher).toValue(mediatorWatcher);
			matchingView = new Sprite();

			UIImpersonator.addChild(container);
		}

		[After]
		public function tearDown():void
		{
			instance = null;
			injector = null;
			mediatorWatcher = null;
		}
		
		[Test]
		public function test_failure_seen():void
		{
			assertThat(true, isTrue());
		}

		[Test]
		public function create_mediator_instantiates_mediator_for_view_when_mapped():void
		{
			instance.map(Sprite).toProcess(new MediatorCreator(ExampleMediator));

			instance.handleView(new Sprite(), null);

			const expectedNotifications:Vector.<String> = new <String>['ExampleMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function doesnt_leave_view_and_mediator_mappings_lying_around():void
		{
			instance.mapMatcher(new TypeMatcher().anyOf(MovieClip, Sprite)).toProcess(new MediatorCreator(ExampleMediator));
			instance.handleView(new Sprite(), null);

			assertThat(injector.hasDirectMapping(MovieClip), isFalse());
			assertThat(injector.hasDirectMapping(Sprite), isFalse());
			assertThat(injector.hasDirectMapping(ExampleMediator), isFalse());
		}

		[Test]
		public function process_instantiates_mediator_for_view_when_matched_to_mapping():void
		{
			instance.map(Sprite).toProcess(new MediatorCreator(ExampleMediator));

			instance.process(new Sprite());

			const expectedNotifications:Vector.<String> = new <String>['ExampleMediator'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}

		[Test]
		public function runs_destroy_on_created_mediator_when_unprocess_runs():void
		{
			instance.map(Sprite).toProcess(new MediatorCreator(ExampleMediator));

			const view:Sprite = new Sprite();
			instance.process(view);
			instance.unprocess(view);

			const expectedNotifications:Vector.<String> = new <String>['ExampleMediator', 'ExampleMediator destroy'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}
		
		[Test(async)]
		public function automatically_unprocesses_when_view_leaves_stage():void
		{
			instance.map(Sprite).toProcess(new MediatorCreator(ExampleMediator));
			container.addChild(matchingView);
			instance.process(matchingView);
			var asyncHandler:Function = Async.asyncHandler( this, checkMediatorsDestroyed, 500 );
			matchingView.addEventListener(Event.REMOVED_FROM_STAGE, asyncHandler);
			container.removeChild(matchingView);
		}
		
		private function checkMediatorsDestroyed(e:Event, params:Object):void
		{
			const expectedNotifications:Vector.<String> = new <String>['ExampleMediator', 'ExampleMediator destroy'];
			assertEqualsVectorsIgnoringOrder(expectedNotifications, mediatorWatcher.notifications);
		}
	}
}

import flash.display.Sprite;
import robotlegs.bender.extensions.mediatorMap.impl.support.MediatorWatcher;

class ExampleMediator
{
	[Inject]
	public var mediatorWatcher:MediatorWatcher;

	[Inject]
	public var view:Sprite;

	public function initialize():void
	{
		mediatorWatcher.notify('ExampleMediator');
	}

	public function destroy():void
	{
		mediatorWatcher.notify('ExampleMediator destroy');
	}
}

class ExampleMediator2
{
	[Inject]
	public var mediatorWatcher:MediatorWatcher;

	[Inject]
	public var view:Sprite;

	public function initialize():void
	{
		mediatorWatcher.notify('ExampleMediator2');
	}

	public function destroy():void
	{
		mediatorWatcher.notify('ExampleMediator2 destroy');
	}
}