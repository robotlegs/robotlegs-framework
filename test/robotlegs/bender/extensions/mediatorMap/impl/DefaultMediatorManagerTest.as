//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import flash.display.Sprite;
	import mx.core.UIComponent;
	import org.flexunit.assertThat;
	import org.flexunit.async.Async;
	import org.fluint.uiImpersonation.UIImpersonator;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import org.hamcrest.object.nullValue;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorMapping;
	import robotlegs.bender.extensions.mediatorMap.support.CallbackMediator;

	public class DefaultMediatorManagerTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var injector:Injector;

		private var factory:MediatorFactory;

		private var manager:DefaultMediatorManager;

		private var container:UIComponent;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before(async, ui)]
		public function before():void
		{
			injector = new Injector();
			factory = new MediatorFactory(injector);
			manager = new DefaultMediatorManager(factory);
			container = new UIComponent();
			UIImpersonator.addChild(container);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test(async, ui)]
		public function mediator_is_removed_when_view_leaves_stage():void
		{
			const view:Sprite = new Sprite();
			const mapping:IMediatorMapping = new MediatorMapping(instanceOf(Sprite), CallbackMediator, factory);
			container.addChild(view);
			mapping.createMediator(view);
			container.removeChild(view);
			assertThat(factory.getMediator(view, mapping), nullValue());
		}

		[Test]
		public function mediator_is_initialized():void
		{
			const expected:Array = ['initialize'];
			const actual:Array = [];
			injector.map(Function, 'initializeCallback').toValue(function(phase:String):void {
				actual.push(phase);
			});
			const mapping:IMediatorMapping = new MediatorMapping(instanceOf(Sprite), SomeMediator, factory);
			mapping.createMediator(new Sprite());
			assertThat(actual, array(expected));
		}

		[Test]
		public function mediator_is_given_view():void
		{
			const expected:Sprite = new Sprite();
			const mapping:IMediatorMapping = new MediatorMapping(instanceOf(Sprite), SomeMediator, factory);
			const mediator:SomeMediator = mapping.createMediator(expected) as SomeMediator;
			assertThat(mediator.view, equalTo(expected));
		}

		[Test]
		public function mediator_is_destroyed():void
		{
			const expected:Array = ['destroy'];
			const actual:Array = [];
			const view:Sprite = new Sprite();
			injector.map(Function, 'destroyCallback').toValue(function(phase:String):void {
				actual.push(phase);
			});
			const mapping:IMediatorMapping = new MediatorMapping(instanceOf(Sprite), SomeMediator, factory);
			mapping.createMediator(view);
			mapping.removeMediator(view);
			assertThat(actual, array(expected));
		}

		[Test(async, ui)]
		public function mediator_for_UIComponent_is_only_initialized_after_creationComplete():void
		{
			const view:UIComponent = new UIComponent();
			const mapping:IMediatorMapping = new MediatorMapping(instanceOf(UIComponent), SomeMediator, factory);
			const mediator:SomeMediator = mapping.createMediator(view) as SomeMediator;
			assertThat(mediator.initialized, isFalse());
			container.addChild(view);
			delayAssertion(function():void {
				assertThat(mediator.initialized, isTrue());
			}, 50)
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function delayAssertion(closure:Function, delay:Number = 50):void
		{
			Async.delayCall(this, closure, delay);
		}
	}
}

class SomeMediator
{

	/*============================================================================*/
	/* Public Properties                                                          */
	/*============================================================================*/

	[Inject(name="initializeCallback", optional="true")]
	public var initializeCallback:Function;

	[Inject(name="destroyCallback", optional="true")]
	public var destroyCallback:Function;

	public var initialized:Boolean;

	public var destroyed:Boolean;

	public var view:Object;

	public function set viewComponent(view:Object):void
	{
		this.view = view;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function initialize():void
	{
		initialized = true;
		initializeCallback && initializeCallback('initialize');
	}

	public function destroy():void
	{
		destroyed = true;
		destroyCallback && destroyCallback('destroy');
	}
}
