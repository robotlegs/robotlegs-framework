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
	import robotlegs.bender.extensions.matching.TypeMatcher;
	import robotlegs.bender.extensions.matching.ITypeFilter;

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
			injector = new Injector();
			factory = new MediatorFactory(injector);
			handler = new MediatorViewHandler(factory);
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
			const mapping:MediatorMapping = new MediatorMapping(createTypeFilter([Sprite]), CallbackMediator);
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
			const mapping:MediatorMapping = new MediatorMapping(createTypeFilter([MovieClip]), CallbackMediator);
			handler.addMapping(mapping);
			handler.handleView(new Sprite(), Sprite);
			assertThat(createdMediator, nullValue());
		}
		
		[Test(expects="robotlegs.bender.framework.api.MappingConfigError")]
		public function error_thrown_if_2_mappings_made_with_same_matcher_and_mediator_one_with_fewer_guards():void
		{
			const mapping:MediatorMapping = new MediatorMapping(createTypeFilter([Sprite]), CallbackMediator); 
			mapping.withGuards(GuardA, GuardB);
			mapping.invalidate();
			mapping.withGuards(GuardA);
			handler.addMapping(mapping);
			handler.handleView(new Sprite(), Sprite);
		}
		
		[Test(expects="robotlegs.bender.framework.api.MappingConfigError")]
		public function error_thrown_if_2_mappings_made_with_same_matcher_and_mediator_one_with_fewer_hooks():void
		{
			const mapping:MediatorMapping = new MediatorMapping(createTypeFilter([Sprite]), CallbackMediator); 
			mapping.withHooks(HookA, HookB);
			mapping.invalidate();
			mapping.withHooks(HookA);
			handler.addMapping(mapping);
			handler.handleView(new Sprite(), Sprite);
		}
		
		/* 
			PRIVATE
		*/
		
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

class GuardA
{
	public function approve():Boolean
	{
		return true;
	}
}

class GuardB
{
	public function approve():Boolean
	{
		return true;
	}
}

class HookA
{
	public function hook():void
	{
	}
}

class HookB
{
	public function hook():void
	{
	}
}