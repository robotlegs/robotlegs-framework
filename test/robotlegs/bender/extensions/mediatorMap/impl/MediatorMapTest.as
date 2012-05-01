//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import flash.display.Sprite;
	import org.flexunit.assertThat;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.notNullValue;
	import org.hamcrest.object.nullValue;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorFactory;
	import robotlegs.bender.extensions.mediatorMap.support.CallbackMediator;
	import robotlegs.bender.extensions.mediatorMap.support.NullMediator;
	import robotlegs.bender.extensions.mediatorMap.support.SupportViewMediator;
	import robotlegs.bender.extensions.viewManager.support.ISupportView;
	import robotlegs.bender.extensions.viewManager.support.SupportView;

	public class MediatorMapTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var injector:Injector;

		private var factory:IMediatorFactory;

		private var mediatorMap:MediatorMap;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			injector = new Injector();
			factory = new MediatorFactory(injector);
			mediatorMap = new MediatorMap(factory);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function map_creates_mapper():void
		{
			assertThat(mediatorMap.map(instanceOf(Sprite)), notNullValue());
		}

		[Test]
		public function map_to_mediator_stores_mapping():void
		{
			mediatorMap.map(instanceOf(Sprite)).toMediator(CallbackMediator);
			assertThat(mediatorMap.getMapping(instanceOf(Sprite)).forMediator(CallbackMediator), notNullValue());
		}

		[Test]
		public function mapType_to_mediator_stores_mapping():void
		{
			mediatorMap.mapType(Sprite).toMediator(CallbackMediator);
			assertThat(mediatorMap.getViewMapping(Sprite).forMediator(CallbackMediator), notNullValue());
		}

		[Test]
		public function unmap_from_mediator_removes_mapping():void
		{
			mediatorMap.map(instanceOf(Sprite)).toMediator(CallbackMediator);
			mediatorMap.unmap(instanceOf(Sprite)).fromMediator(CallbackMediator);
			assertThat(mediatorMap.getMapping(instanceOf(Sprite)).forMediator(CallbackMediator), nullValue());
		}

		[Test]
		public function unmapType_from_mediator_removes_mapping():void
		{
			mediatorMap.mapType(Sprite).toMediator(CallbackMediator);
			mediatorMap.unmapType(Sprite).fromMediator(CallbackMediator);
			assertThat(mediatorMap.getViewMapping(Sprite).forMediator(CallbackMediator), nullValue());
		}

		[Test]
		public function unmap_from_all_removes_mappings():void
		{
			mediatorMap.map(instanceOf(Sprite)).toMediator(CallbackMediator);
			mediatorMap.map(instanceOf(Sprite)).toMediator(NullMediator);
			mediatorMap.unmap(instanceOf(Sprite)).fromMediators();
			assertThat(mediatorMap.getMapping(instanceOf(Sprite)).forMediator(CallbackMediator), nullValue());
			assertThat(mediatorMap.getMapping(instanceOf(Sprite)).forMediator(NullMediator), nullValue());
		}

		[Test]
		public function unmapType_from_all_removes_mappings():void
		{
			mediatorMap.mapType(Sprite).toMediator(CallbackMediator);
			mediatorMap.mapType(Sprite).toMediator(NullMediator);
			mediatorMap.unmapType(Sprite).fromMediators();
			assertThat(mediatorMap.getViewMapping(Sprite).forMediator(CallbackMediator), nullValue());
			assertThat(mediatorMap.getViewMapping(Sprite).forMediator(NullMediator), nullValue());
		}

		[Test]
		public function view_is_handled():void
		{
			var actual:Object;
			injector.map(Function, 'callback').toValue(function(mediator:Object):void {
				actual = mediator;
			});
			mediatorMap.map(instanceOf(SupportView)).toMediator(CallbackMediator);
			mediatorMap.handleView(new SupportView(), SupportView);
			assertThat(actual, instanceOf(CallbackMediator));
		}

		[Test]
		public function view_type_is_handled():void
		{
			var actual:Object;
			injector.map(Function, 'callback').toValue(function(mediator:Object):void {
				actual = mediator;
			});
			mediatorMap.mapType(ISupportView).toMediator(SupportViewMediator);
			mediatorMap.handleView(new SupportView(), SupportView);
			assertThat(actual, instanceOf(SupportViewMediator));
		}
	}
}
