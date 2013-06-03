//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import mockolate.received;
	import mockolate.runner.MockolateRule;
	import org.flexunit.assertThat;
	import org.flexunit.asserts.assertEqualsVectorsIgnoringOrder;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.notNullValue;
	import org.hamcrest.object.nullValue;
	import robotlegs.bender.extensions.matching.ITypeFilter;
	import robotlegs.bender.extensions.matching.TypeMatcher;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
	import robotlegs.bender.extensions.mediatorMap.support.CallbackMediator;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.impl.RobotlegsInjector;
	import robotlegs.bender.framework.impl.guardSupport.GrumpyGuard;
	import robotlegs.bender.framework.impl.guardSupport.HappyGuard;
	import robotlegs.bender.framework.impl.hookSupport.CallbackHook;

	public class MediatorFactoryTest
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Rule]
		public var mocks:MockolateRule = new MockolateRule();

		[Mock]
		public var manager:MediatorManager;

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var injector:IInjector;

		private var factory:MediatorFactory;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			injector = new RobotlegsInjector();
			factory = new MediatorFactory(injector);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function mediator_is_created():void
		{
			const mapping:IMediatorMapping = new MediatorMapping(createTypeFilter([Sprite]), CallbackMediator);
			const mediator:Object = factory.createMediators(new Sprite(), Sprite, [mapping])[0];
			assertThat(mediator, instanceOf(CallbackMediator));
		}

		[Test]
		public function mediator_is_injected_into():void
		{
			const expected:Number = 128;
			const mapping:IMediatorMapping = new MediatorMapping(createTypeFilter([Sprite]), InjectedMediator);
			injector.map(Number).toValue(expected);
			const mediator:InjectedMediator = factory.createMediators(new Sprite(), Sprite, [mapping])[0];
			assertThat(mediator.number, equalTo(expected));
		}

		[Test]
		public function mediatedItem_is_injected_as_exact_type_into_mediator():void
		{
			const expected:Sprite = new Sprite();
			const mapping:IMediatorMapping = new MediatorMapping(createTypeFilter([Sprite]), ViewInjectedMediator);
			const mediator:ViewInjectedMediator = factory.createMediators(expected, Sprite, [mapping])[0];
			assertThat(mediator.mediatedItem, equalTo(expected));
		}

		[Test]
		public function mediatedItem_is_injected_as_requested_type_into_mediator():void
		{
			const expected:Sprite = new Sprite();

			const mapping:MediatorMapping =
				new MediatorMapping(createTypeFilter([DisplayObject]), ViewInjectedAsRequestedMediator);

			const mediator:ViewInjectedAsRequestedMediator =
				factory.createMediators(expected, Sprite, [mapping])[0];

			assertThat(mediator.mediatedItem, equalTo(expected));
		}

		[Test]
		public function hooks_are_called():void
		{
			assertThat(hookCallCount(CallbackHook, CallbackHook), equalTo(2));
		}

		[Test]
		public function hook_receives_mediator_and_mediatedItem():void
		{
			const mediatedItem:Sprite = new Sprite();
			var injectedMediator:Object = null;
			var injectedView:Object = null;
			injector.map(Function, 'callback').toValue(function(hook:MediatorHook):void {
				injectedMediator = hook.mediator;
				injectedView = hook.mediatedItem;
			});
			const mapping:MediatorMapping =
				new MediatorMapping(createTypeFilter([Sprite]), ViewInjectedMediator);

			mapping.withHooks(MediatorHook);

			factory.createMediators(mediatedItem, Sprite, [mapping]);

			assertThat(injectedMediator, instanceOf(ViewInjectedMediator));
			assertThat(injectedView, equalTo(mediatedItem));
		}

		[Test]
		public function mediator_is_created_when_the_guard_allows():void
		{
			assertThat(mediatorsCreatedWithGuards(HappyGuard), equalTo(1));
		}

		[Test]
		public function mediator_is_created_when_all_guards_allow():void
		{
			assertThat(mediatorsCreatedWithGuards(HappyGuard, HappyGuard), equalTo(1));
		}

		[Test]
		public function mediator_is_not_created_when_the_guard_denies():void
		{
			assertThat(mediatorsCreatedWithGuards(GrumpyGuard), equalTo(0));
		}

		[Test]
		public function mediator_is_not_created_when_any_guards_denies():void
		{
			assertThat(mediatorsCreatedWithGuards(HappyGuard, GrumpyGuard), equalTo(0));
		}

		[Test]
		public function mediator_is_not_created_when_all_guards_deny():void
		{
			assertThat(mediatorsCreatedWithGuards(GrumpyGuard, GrumpyGuard), equalTo(0));
		}

		[Test]
		public function same_mediators_are_returned_for_mappings_and_mediatedItem():void
		{
			const mediatedItem:Sprite = new Sprite();
			const mapping1:MediatorMapping =
				new MediatorMapping(createTypeFilter([Sprite]), ViewInjectedMediator);
			const mapping2:MediatorMapping =
				new MediatorMapping(createTypeFilter([DisplayObject]), ViewInjectedAsRequestedMediator);
			const mediators1:Array = factory.createMediators(mediatedItem, Sprite, [mapping1, mapping2]);
			const mediators2:Array = factory.createMediators(mediatedItem, Sprite, [mapping1, mapping2]);
			assertEqualsVectorsIgnoringOrder(mediators1, mediators2);
		}

		[Test]
		public function expected_number_of_mediators_are_returned_for_mappings_and_mediatedItem():void
		{
			const mediatedItem:Sprite = new Sprite();
			const mapping1:MediatorMapping =
				new MediatorMapping(createTypeFilter([Sprite]), ViewInjectedMediator);
			const mapping2:MediatorMapping =
				new MediatorMapping(createTypeFilter([DisplayObject]), ViewInjectedAsRequestedMediator);
			const mediators:Array = factory.createMediators(mediatedItem, Sprite, [mapping1, mapping2]);
			assertThat(mediators.length, equalTo(2));
		}

		[Test]
		public function getMediator():void
		{
			const mediatedItem:Sprite = new Sprite();
			const mapping:IMediatorMapping = new MediatorMapping(createTypeFilter([Sprite]), CallbackMediator);
			factory.createMediators(mediatedItem, Sprite, [mapping]);
			assertThat(factory.getMediator(mediatedItem, mapping), notNullValue());
		}

		[Test]
		public function removeMediator():void
		{
			const mediatedItem:Sprite = new Sprite();
			const mapping:IMediatorMapping = new MediatorMapping(createTypeFilter([Sprite]), CallbackMediator);
			factory.createMediators(mediatedItem, Sprite, [mapping]);
			factory.removeMediators(mediatedItem);
			assertThat(factory.getMediator(mediatedItem, mapping), nullValue());
		}

		[Test]
		public function creating_mediator_gives_mediator_to_mediator_manager():void
		{
			const mediatedItem:Sprite = new Sprite();
			const mapping:IMediatorMapping = new MediatorMapping(createTypeFilter([Sprite]), CallbackMediator);
			factory = new MediatorFactory(injector, manager);
			factory.createMediators(mediatedItem, Sprite, [mapping]);
			factory.createMediators(mediatedItem, Sprite, [mapping]);
			assertThat(manager, received().method('addMediator')
				.args(instanceOf(CallbackMediator), mediatedItem, mapping).once());
		}

		[Test]
		public function removeMediator_removes_mediator_from_manager():void
		{
			const mediatedItem:Sprite = new Sprite();
			const mapping:IMediatorMapping = new MediatorMapping(createTypeFilter([Sprite]), CallbackMediator);
			factory = new MediatorFactory(injector, manager);
			factory.createMediators(mediatedItem, Sprite, [mapping]);
			factory.removeMediators(mediatedItem);
			factory.removeMediators(mediatedItem);
			assertThat(manager, received().method('removeMediator')
				.args(instanceOf(CallbackMediator), mediatedItem, mapping).once());
		}

		[Test]
		public function removeAllMediators_removes_all_mediators_from_manager():void
		{
			const mediatedItem1:Sprite = new Sprite();
			const mediatedItem2:Sprite = new Sprite();
			const mapping1:IMediatorMapping = new MediatorMapping(createTypeFilter([Sprite]), CallbackMediator);
			const mapping2:IMediatorMapping = new MediatorMapping(createTypeFilter([DisplayObject]), ViewInjectedAsRequestedMediator);

			factory = new MediatorFactory(injector, manager);
			factory.createMediators(mediatedItem1, Sprite, [mapping1, mapping2]);
			factory.createMediators(mediatedItem2, Sprite, [mapping1, mapping2]);
			factory.removeAllMediators();

			assertThat(manager, received().method('removeMediator')
				.args(instanceOf(CallbackMediator), mediatedItem1, mapping1).once());

			assertThat(manager, received().method('removeMediator')
				.args(instanceOf(ViewInjectedAsRequestedMediator), mediatedItem1, mapping2).once());

			assertThat(manager, received().method('removeMediator')
				.args(instanceOf(CallbackMediator), mediatedItem2, mapping1).once());

			assertThat(manager, received().method('removeMediator')
				.args(instanceOf(ViewInjectedAsRequestedMediator), mediatedItem2, mapping2).once());
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function hookCallCount(... hooks):uint
		{
			var hookCallCount:int = 0;
			injector.map(Function, 'hookCallback').toValue(function():void {
				hookCallCount++;
			});
			const mapping:MediatorMapping = new MediatorMapping(createTypeFilter([Sprite]), CallbackMediator);
			mapping.withHooks(hooks);
			factory.createMediators(new Sprite(), Sprite, [mapping]);
			return hookCallCount;
		}

		private function mediatorsCreatedWithGuards(... guards):uint
		{
			const mapping:MediatorMapping = new MediatorMapping(createTypeFilter([Sprite]), CallbackMediator);
			mapping.withGuards(guards);
			const mediators:Array = factory.createMediators(new Sprite(), Sprite, [mapping]);
			return mediators.length;
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

import flash.display.DisplayObject;
import flash.display.Sprite;

class InjectedMediator
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var number:Number;
}

class ViewInjectedMediator
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var mediatedItem:Sprite;
}

class ViewInjectedAsRequestedMediator
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var mediatedItem:DisplayObject;
}

class MediatorHook
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var mediatedItem:Sprite;

	[Inject]
	public var mediator:ViewInjectedMediator;

	[Inject(name="callback", optional="true")]
	public var callback:Function;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function hook():void
	{
		callback && callback(this);
	}
}
