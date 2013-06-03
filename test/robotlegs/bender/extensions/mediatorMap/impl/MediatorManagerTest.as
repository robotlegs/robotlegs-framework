//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import flash.display.Sprite;
	import mx.core.UIComponent;
	import mockolate.received;
	import mockolate.runner.MockolateRule;
	import mockolate.stub;
	import org.flexunit.assertThat;
	import org.flexunit.async.Async;
	import org.fluint.uiImpersonation.UIImpersonator;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import robotlegs.bender.extensions.matching.ITypeFilter;
	import robotlegs.bender.extensions.matching.TypeMatcher;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
	import robotlegs.bender.extensions.mediatorMap.impl.support.LifecycleReportingMediator;
	import robotlegs.bender.extensions.mediatorMap.support.CallbackMediator;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.impl.RobotlegsInjector;
	import utils.checkFlex;
	import utils.traceAndSkipTest;

	public class MediatorManagerTest
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var factory:MediatorFactory;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var injector:IInjector;

		private var manager:MediatorManager;

		private var container:UIComponent;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before(ui)]
		public function before():void
		{
			injector = new RobotlegsInjector();
			manager = new MediatorManager(factory);
			container = new UIComponent();
			UIImpersonator.addChild(container);
		}

		[After(ui)]
		public function tearDown():void
		{
			UIImpersonator.removeChild(container);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test(ui)]
		public function mediator_is_removed_from_factory_when_view_leaves_stage():void
		{
			const view:Sprite = new Sprite();
			const mapping:IMediatorMapping = new MediatorMapping(createTypeFilter([Sprite]), CallbackMediator);
			const mediator:Object = injector.instantiateUnmapped(CallbackMediator);
			container.addChild(view);
			manager.addMediator(mediator, view, mapping);
			container.removeChild(view);
			assertThat(factory, received().method('removeMediators').args(view).once());
		}

		[Test(ui)]
		public function mediator_is_NOT_removed_when_view_leaves_stage_when_autoRemove_is_false():void
		{
			const view:Sprite = new Sprite();
			const mapping:MediatorMapping = new MediatorMapping(createTypeFilter([Sprite]), CallbackMediator);
			mapping.autoRemove(false);
			const mediator:Object = injector.instantiateUnmapped(CallbackMediator);
			container.addChild(view);
			manager.addMediator(mediator, view, mapping);
			container.removeChild(view);
			assertThat(factory, received().method('removeMediators').never());
		}

		[Test]
		public function mediator_lifecycle_methods_are_invoked():void
		{
			const expected:Array = [
				'preInitialize', 'initialize', 'postInitialize',
				'preDestroy', 'destroy', 'postDestroy'];
			const actual:Array = [];
			for each (var phase:String in expected)
			{
				injector.map(Function, phase + 'Callback').toValue(function(ph:String):void {
					actual.push(ph);
				});
			}
			const item:Sprite = new Sprite();
			const mediator:Object = injector.instantiateUnmapped(LifecycleReportingMediator);
			const mapping:IMediatorMapping = new MediatorMapping(createTypeFilter([Sprite]), LifecycleReportingMediator);
			manager.addMediator(mediator, item, mapping);
			manager.removeMediator(mediator, item, mapping);
			assertThat(actual, array(expected));
		}

		[Test]
		public function mediator_is_given_view():void
		{
			const expected:Sprite = new Sprite();
			const mapping:IMediatorMapping = new MediatorMapping(createTypeFilter([Sprite]), LifecycleReportingMediator);
			const mediator:LifecycleReportingMediator = injector.instantiateUnmapped(LifecycleReportingMediator);
			manager.addMediator(mediator, expected, mapping);
			assertThat(mediator.view, equalTo(expected));
		}

		[Test(async, ui)]
		public function mediator_for_UIComponent_is_only_initialized_after_creationComplete():void
		{
			// early exit for as3 only test environments
			if (!checkFlex())
				return traceAndSkipTest('mediator_for_UIComponent_is_only_initialized_after_creationComplete - flex not available');

			const view:UIComponent = new UIComponent();
			const mapping:IMediatorMapping = new MediatorMapping(createTypeFilter([UIComponent]), LifecycleReportingMediator);
			const mediator:LifecycleReportingMediator = injector.instantiateUnmapped(LifecycleReportingMediator);

			// we have to stub this out otherwise the manager assumes
			// that the mediator has been removed in the background
			stub(factory).method('getMediator').anyArgs().returns(mediator);

			manager.addMediator(mediator, view, mapping);
			assertThat("mediator starts off uninitialized", mediator.initialized, isFalse());
			container.addChild(view);

			delayAssertion(function():void {
				assertThat("mediator is eventually initialized", mediator.initialized, isTrue());
			}, 100);
		}

		[Test]
		public function mediator_is_given_NonDisplayObject_view():void
		{
			const expected:Number = 1.5;
			const mapping:IMediatorMapping = new MediatorMapping(createTypeFilter([Number]), LifecycleReportingMediator);
			const mediator:LifecycleReportingMediator = injector.instantiateUnmapped(LifecycleReportingMediator);
			manager.addMediator(mediator, expected, mapping);
			assertThat(mediator.view, equalTo(expected));
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function delayAssertion(closure:Function, delay:Number = 50):void
		{
			Async.delayCall(this, closure, delay);
		}

		private function createTypeFilter(allOf:Array, anyOf:Array = null, noneOf:Array = null):ITypeFilter
		{
			const matcher:TypeMatcher = new TypeMatcher();
			if (allOf)
				matcher.allOf(allOf);
			if (anyOf)
				matcher.anyOf(anyOf);
			if (noneOf)
				matcher.noneOf(noneOf);

			return matcher.createTypeFilter();
		}
	}
}
