//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import org.flexunit.assertThat;
	import org.hamcrest.object.notNullValue;
	import org.hamcrest.object.nullValue;
	import robotlegs.bender.extensions.matching.ITypeFilter;
	import robotlegs.bender.extensions.matching.TypeMatcher;
	import robotlegs.bender.extensions.mediatorMap.support.CallbackMediator;
	import robotlegs.bender.framework.api.IInjector;
	import robotlegs.bender.framework.impl.RobotlegsInjector;

	public class MediatorViewHandlerTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var handler:MediatorViewHandler;

		private var injector:IInjector;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			injector = new RobotlegsInjector();
			handler = new MediatorViewHandler(new MediatorFactory(injector));
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function view_is_handled():void
		{
			var createdMediator:Object = null;
			injector.map(Function, 'callback').toValue(function(mediator:Object):void {
				createdMediator = mediator;
			});
			const mapping:MediatorMapping = new MediatorMapping(createTypeFilter([Sprite]), CallbackMediator);
			handler.addMapping(mapping);
			handler.handleView(new Sprite(), Sprite);
			assertThat(createdMediator, notNullValue());
		}

		[Test]
		public function view_is_not_handled():void
		{
			var createdMediator:Object = null;
			injector.map(Function, 'callback').toValue(function(mediator:Object):void {
				createdMediator = mediator;
			});
			const mapping:MediatorMapping = new MediatorMapping(createTypeFilter([MovieClip]), CallbackMediator);
			handler.addMapping(mapping);
			handler.handleView(new Sprite(), Sprite);
			assertThat(createdMediator, nullValue());
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

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
