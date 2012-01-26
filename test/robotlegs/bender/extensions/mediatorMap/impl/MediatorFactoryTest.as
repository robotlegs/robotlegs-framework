//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import org.flexunit.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import org.hamcrest.object.notNullValue;
	import org.hamcrest.object.nullValue;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
	import robotlegs.bender.extensions.mediatorMap.api.MediatorFactoryEvent;
	import robotlegs.bender.extensions.mediatorMap.support.CallbackMediator;
	import robotlegs.bender.framework.guard.support.GrumpyGuard;
	import robotlegs.bender.framework.guard.support.HappyGuard;
	import robotlegs.bender.framework.hook.support.CallbackHook;

	public class MediatorFactoryTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var injector:Injector;

		private var factory:MediatorFactory;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			injector = new Injector();
			factory = new MediatorFactory(injector);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function mediator_is_created():void
		{
			const mapping:IMediatorMapping = new MediatorMapping(instanceOf(Sprite), CallbackMediator, factory);
			const mediator:Object = factory.createMediator(new Sprite(), mapping);
			assertThat(mediator, instanceOf(CallbackMediator));
		}

		[Test]
		public function mediator_is_injected_into():void
		{
			const expected:Number = 128;
			const mapping:IMediatorMapping = new MediatorMapping(instanceOf(Sprite), InjectedMediator, factory);
			injector.map(Number).toValue(expected);
			const mediator:InjectedMediator = factory.createMediator(new Sprite(), mapping) as InjectedMediator;
			assertThat(mediator.number, equalTo(expected));
		}

		[Test]
		public function view_is_injected_as_exact_type_into_mediator():void
		{
			const expected:Sprite = new Sprite();
			const mapping:IMediatorMapping = new MediatorMapping(instanceOf(Sprite), ViewInjectedMediator, factory);
			const mediator:ViewInjectedMediator = factory.createMediator(expected, mapping) as ViewInjectedMediator;
			assertThat(mediator.view, equalTo(expected));
		}

		[Test]
		public function view_is_injected_as_requested_type_into_mediator():void
		{
			const expected:Sprite = new Sprite();

			const mapping:MediatorMapping =
				new MediatorMapping(instanceOf(Sprite), ViewInjectedAsRequestedMediator, factory, DisplayObject);

			const mediator:ViewInjectedAsRequestedMediator =
				factory.createMediator(expected, mapping) as ViewInjectedAsRequestedMediator;

			assertThat(mediator.view, equalTo(expected));
		}

		[Test]
		public function hooks_are_called():void
		{
			assertThat(hookCallCount(CallbackHook, CallbackHook), equalTo(2));
		}

		[Test]
		public function hook_receives_mediator_and_view():void
		{
			const view:Sprite = new Sprite();
			var injectedMediator:Object;
			var injectedView:Object;
			injector.map(Function, 'callback').toValue(function(hook:MediatorHook):void {
				injectedMediator = hook.mediator;
				injectedView = hook.view;
			});
			const mapping:MediatorMapping =
				new MediatorMapping(instanceOf(Sprite), ViewInjectedMediator, factory);

			mapping.withHooks(MediatorHook);

			factory.createMediator(view, mapping);

			assertThat(injectedMediator, instanceOf(ViewInjectedMediator));
			assertThat(injectedView, equalTo(view));
		}

		[Test]
		public function mediator_is_created_when_the_guard_allows():void
		{
			assertThat(mediatorCreatedWithGuards(HappyGuard), isTrue());
		}

		[Test]
		public function mediator_is_created_when_all_guards_allow():void
		{
			assertThat(mediatorCreatedWithGuards(HappyGuard, HappyGuard), isTrue());
		}

		[Test]
		public function mediator_is_not_created_when_the_guard_denies():void
		{
			assertThat(mediatorCreatedWithGuards(GrumpyGuard), isFalse());
		}

		[Test]
		public function mediator_is_not_created_when_any_guards_denies():void
		{
			assertThat(mediatorCreatedWithGuards(HappyGuard, GrumpyGuard), isFalse());
		}

		[Test]
		public function mediator_is_not_created_when_all_guards_deny():void
		{
			assertThat(mediatorCreatedWithGuards(GrumpyGuard, GrumpyGuard), isFalse());
		}

		[Test]
		public function same_mediator_is_returned_for_mapping_and_view():void
		{
			const view:Sprite = new Sprite();
			const mapping:MediatorMapping =
				new MediatorMapping(instanceOf(Sprite), ViewInjectedMediator, factory);
			const mediator1:Object = factory.createMediator(view, mapping);
			const mediator2:Object = factory.createMediator(view, mapping);
			assertThat(mediator1, equalTo(mediator2));
		}

		[Test]
		public function creating_mediator_fires_event_once():void
		{
			var callCount:int;
			factory.addEventListener(MediatorFactoryEvent.MEDIATOR_CREATE, function(event:MediatorFactoryEvent):void {
				callCount++;
			});
			const view:Sprite = new Sprite();
			const mapping:IMediatorMapping = new MediatorMapping(instanceOf(Sprite), CallbackMediator, factory);
			factory.createMediator(view, mapping);
			factory.createMediator(view, mapping);
			assertThat(callCount, equalTo(1));
		}

		[Test]
		public function getMediator():void
		{
			const view:Sprite = new Sprite();
			const mapping:IMediatorMapping = new MediatorMapping(instanceOf(Sprite), CallbackMediator, factory);
			factory.createMediator(view, mapping);
			assertThat(factory.getMediator(view, mapping), notNullValue());
		}

		[Test]
		public function removeMediator():void
		{
			const view:Sprite = new Sprite();
			const mapping:IMediatorMapping = new MediatorMapping(instanceOf(Sprite), CallbackMediator, factory);
			factory.createMediator(view, mapping);
			factory.removeMediator(view, mapping);
			assertThat(factory.getMediator(view, mapping), nullValue());
		}

		[Test]
		public function removeMediator_fires_event_once():void
		{
			var callCount:int;
			factory.addEventListener(MediatorFactoryEvent.MEDIATOR_REMOVE, function(event:MediatorFactoryEvent):void {
				callCount++;
			});
			const view:Sprite = new Sprite();
			const mapping:IMediatorMapping = new MediatorMapping(instanceOf(Sprite), CallbackMediator, factory);
			factory.createMediator(view, mapping);
			factory.removeMediator(view, mapping);
			factory.removeMediator(view, mapping);
			assertThat(callCount, equalTo(1));
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function hookCallCount(... hooks):uint
		{
			var hookCallCount:uint;
			injector.map(Function, 'hookCallback').toValue(function():void {
				hookCallCount++;
			});
			const mapping:MediatorMapping = new MediatorMapping(instanceOf(Sprite), CallbackMediator, factory);
			mapping.withHooks(hooks);
			factory.createMediator(new Sprite(), mapping);
			return hookCallCount;
		}

		private function mediatorCreatedWithGuards(... guards):Boolean
		{
			const mapping:MediatorMapping = new MediatorMapping(instanceOf(Sprite), CallbackMediator, factory);
			mapping.withGuards(guards);
			return factory.createMediator(new Sprite(), mapping);
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
	public var view:Sprite;
}

class ViewInjectedAsRequestedMediator
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var view:DisplayObject;
}

class MediatorHook
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject]
	public var view:Sprite;

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
