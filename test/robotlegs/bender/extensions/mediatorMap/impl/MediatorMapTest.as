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

	public class MediatorMapTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var injector:Injector;

		private var mediatorFactory:IMediatorFactory;

		private var mediatorMap:MediatorMap;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			injector = new Injector();
			mediatorFactory = new DefaultMediatorFactory(injector);
			mediatorMap = new MediatorMap(mediatorFactory);
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
		public function unmap_from_mediator_removes_mapping():void
		{
			mediatorMap.map(instanceOf(Sprite)).toMediator(CallbackMediator);
			mediatorMap.unmap(instanceOf(Sprite)).fromMediator(CallbackMediator);
			assertThat(mediatorMap.getMapping(instanceOf(Sprite)).forMediator(CallbackMediator), nullValue());
		}

		[Test]
		public function view_is_handled():void
		{
			var actual:Object;
			injector.map(Function, 'callback').toValue(function(mediator:Object):void {
				actual = mediator;
			});
			mediatorMap.map(instanceOf(Sprite)).toMediator(CallbackMediator);
			mediatorMap.handleView(new Sprite(), Sprite);
			assertThat(actual, notNullValue());
		}
	}
}
