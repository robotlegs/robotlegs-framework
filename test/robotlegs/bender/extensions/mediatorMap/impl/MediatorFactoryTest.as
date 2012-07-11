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
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.notNullValue;
	import org.hamcrest.object.nullValue;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
	import robotlegs.bender.extensions.mediatorMap.api.MediatorFactoryEvent;
	import robotlegs.bender.extensions.mediatorMap.support.CallbackMediator;
	import robotlegs.bender.extensions.matching.TypeMatcher;
	import org.flexunit.asserts.assertEqualsVectorsIgnoringOrder;
	import robotlegs.bender.extensions.matching.ITypeFilter;
	import robotlegs.bender.framework.impl.guardSupport.GrumpyGuard;
	import robotlegs.bender.framework.impl.guardSupport.HappyGuard;
	import robotlegs.bender.framework.impl.hookSupport.CallbackHook;

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
		public function view_is_injected_as_exact_type_into_mediator():void
		{
			const expected:Sprite = new Sprite();
			const mapping:IMediatorMapping = new MediatorMapping(createTypeFilter([Sprite]), ViewInjectedMediator);
			const mediator:ViewInjectedMediator = factory.createMediators(expected, Sprite, [mapping])[0];
			assertThat(mediator.view, equalTo(expected));
		}

		[Test]
		public function view_is_injected_as_requested_type_into_mediator():void
		{
			const expected:Sprite = new Sprite();

			const mapping:MediatorMapping =
				new MediatorMapping(createTypeFilter([DisplayObject]), ViewInjectedAsRequestedMediator);

			const mediator:ViewInjectedAsRequestedMediator =
				factory.createMediators(expected, Sprite, [mapping])[0];
			
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
				new MediatorMapping(createTypeFilter([Sprite]), ViewInjectedMediator);

			mapping.withHooks(MediatorHook);

			factory.createMediators(view, Sprite, [mapping]);

			assertThat(injectedMediator, instanceOf(ViewInjectedMediator));
			assertThat(injectedView, equalTo(view));
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
		public function same_mediators_are_returned_for_mappings_and_view():void
		{
			const view:Sprite = new Sprite();
			const mapping1:MediatorMapping =
				new MediatorMapping(createTypeFilter([Sprite]), ViewInjectedMediator);
			const mapping2:MediatorMapping =
				new MediatorMapping(createTypeFilter([DisplayObject]), ViewInjectedAsRequestedMediator);
			const mediators1:Array = factory.createMediators(view, Sprite, [mapping1, mapping2]);
			const mediators2:Array = factory.createMediators(view, Sprite, [mapping1, mapping2]);
			assertEqualsVectorsIgnoringOrder(mediators1, mediators2);
		}
		
		[Test]
		public function expected_number_of_mediators_are_returned_for_mappings_and_view():void
		{
			const view:Sprite = new Sprite();
			const mapping1:MediatorMapping =
				new MediatorMapping(createTypeFilter([Sprite]), ViewInjectedMediator);
			const mapping2:MediatorMapping =
				new MediatorMapping(createTypeFilter([DisplayObject]), ViewInjectedAsRequestedMediator);
			const mediators:Array = factory.createMediators(view, Sprite, [mapping1, mapping2]);
			assertThat(mediators.length, equalTo(2));
		}

		[Test]
		public function creating_mediator_fires_event_once():void
		{
			var callCount:int;
			factory.addEventListener(MediatorFactoryEvent.MEDIATOR_CREATE, function(event:MediatorFactoryEvent):void {
				callCount++;
			});
			const view:Sprite = new Sprite();
			const mapping:IMediatorMapping = new MediatorMapping(createTypeFilter([Sprite]), CallbackMediator);
			factory.createMediators(view, Sprite, [mapping]);
			factory.createMediators(view, Sprite, [mapping]);
			assertThat(callCount, equalTo(1));
		}

		[Test]
		public function getMediator():void
		{
			const view:Sprite = new Sprite();
			const mapping:IMediatorMapping = new MediatorMapping(createTypeFilter([Sprite]), CallbackMediator);
			factory.createMediators(view, Sprite, [mapping]);
			assertThat(factory.getMediator(view, mapping), notNullValue());
		}

		[Test]
		public function removeMediators():void
		{
			const view:Sprite = new Sprite();
			const mapping:IMediatorMapping = new MediatorMapping(createTypeFilter([Sprite]), CallbackMediator);
			factory.createMediators(view, Sprite, [mapping]);
			factory.removeMediators(view);
			assertThat(factory.getMediator(view, mapping), nullValue());
		}
		
		[Test]
		public function removeAllMediators_removes_mediators_for_all_views():void
		{
			const view1:Sprite = new Sprite();
			const view2:Sprite = new Sprite();
			const mapping1:IMediatorMapping = new MediatorMapping(createTypeFilter([Sprite]), CallbackMediator);
			const mapping2:IMediatorMapping = new MediatorMapping(createTypeFilter([DisplayObject]), ViewInjectedAsRequestedMediator);
			
			factory.createMediators(view1, Sprite, [mapping1, mapping2]);
			factory.createMediators(view2, Sprite, [mapping1, mapping2]);
			
			const mediatorsRemovedForView:Array = [];
			
			factory.addEventListener(MediatorFactoryEvent.MEDIATOR_REMOVE, function(event:MediatorFactoryEvent):void {
				mediatorsRemovedForView.push(event.view);
			});

			factory.removeAllMediators();
			
			assertThat(mediatorsRemovedForView.length, equalTo(4));
		}

		[Test]
		public function removeMediator_fires_event_once():void
		{
			var callCount:int;
			factory.addEventListener(MediatorFactoryEvent.MEDIATOR_REMOVE, function(event:MediatorFactoryEvent):void {
				callCount++;
			});
			const view:Sprite = new Sprite();
			const mapping:IMediatorMapping = new MediatorMapping(createTypeFilter([Sprite]), CallbackMediator);
			factory.createMediators(view, Sprite, [mapping]);
			factory.removeMediators(view);
			factory.removeMediators(view);
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
			if(allOf)
				matcher.allOf(allOf);
			if(anyOf)
				matcher.anyOf(anyOf);
			if(noneOf)
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