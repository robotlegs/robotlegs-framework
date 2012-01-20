//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import org.flexunit.assertThat;
	import org.hamcrest.object.instanceOf;
	import org.hamcrest.object.notNullValue;
	import org.hamcrest.object.nullValue;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.mediatorMap.support.CallbackMediator;

	public class MediatorViewHandlerTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var handler:MediatorViewHandler;

		private var injector:Injector;

		private var factory:MediatorFactory;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			handler = new MediatorViewHandler();
			injector = new Injector();
			factory = new MediatorFactory(injector);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function view_is_handled():void
		{
			var createdMediator:Object;
			injector.map(Function, 'callback').toValue(function(mediator:Object):void {
				createdMediator = mediator;
			});
			const mapping:MediatorMapping = new MediatorMapping(instanceOf(Sprite), CallbackMediator, factory);
			handler.addMapping(mapping);
			handler.handleView(new Sprite(), Sprite);
			assertThat(createdMediator, notNullValue());
		}

		[Test]
		public function view_is_not_handled():void
		{
			var createdMediator:Object;
			injector.map(Function, 'callback').toValue(function(mediator:Object):void {
				createdMediator = mediator;
			});
			const mapping:MediatorMapping = new MediatorMapping(instanceOf(MovieClip), CallbackMediator, factory);
			handler.addMapping(mapping);
			handler.handleView(new Sprite(), Sprite);
			assertThat(createdMediator, nullValue());
		}
	}
}
