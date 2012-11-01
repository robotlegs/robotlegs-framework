//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.scopedEventDispatcher
{
	import flash.events.IEventDispatcher;
	import mx.core.UIComponent;
	import org.flexunit.assertThat;
	import org.fluint.uiImpersonation.UIImpersonator;
	import org.hamcrest.collection.array;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.instanceOf;
	import robotlegs.bender.extensions.contextView.ContextViewExtension;
	import robotlegs.bender.extensions.modularity.ModularityExtension;
	import robotlegs.bender.extensions.stageSync.StageSyncExtension;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.impl.Context;
	import org.swiftsuspenders.Injector;

	public class ScopedEventDispatcherExtensionTest
	{

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function named_EventDispatcher_is_mapped_into_injector():void
		{
			const name:String = 'global';
			const context:IContext = new Context();
			var actual:Object = null;
			context.extend(new ScopedEventDispatcherExtension(name));
			context.lifecycle.whenInitializing( function():void {
				actual = context.injector.getInstance(IEventDispatcher, name);
			});
			context.lifecycle.initialize();
			assertThat(actual, instanceOf(IEventDispatcher));
		}

		[Test]
		public function named_EventDispatchers_are_mapped_into_injector():void
		{
			const names:Array = ['global', 'other', 'name'];
			const dispatchers:Array = [];
			const context:IContext = new Context();
			context.extend(new ScopedEventDispatcherExtension('global', 'other', 'name'));
			context.lifecycle.whenInitializing( function():void {
				for each (var name:String in names)
				{
					dispatchers.push(context.injector.getInstance(IEventDispatcher, name));
				}
			});
			context.lifecycle.initialize();
			assertThat(dispatchers.length, equalTo(3));
		}

		[Test(async, ui)]
		public function event_dispatchers_are_inherited():void
		{
			const names:Array = ['global', 'other', 'name'];
			const container:UIComponent = new UIComponent();
			const parentView:UIComponent = new UIComponent();
			const childView:UIComponent = new UIComponent();

			const parentContext:IContext = new Context().extend(
				ModularityExtension,
				StageSyncExtension,
				ContextViewExtension,
				new ScopedEventDispatcherExtension('global', 'other', 'name'))
				.configure(parentView);

			const childContext:IContext = new Context().extend(
				ModularityExtension,
				StageSyncExtension,
				ContextViewExtension,
				new ScopedEventDispatcherExtension('global', 'other', 'name'))
				.configure(childView);

			container.addChild(parentView);
			parentView.addChild(childView);
			UIImpersonator.addChild(container);

			const parentDispatchers:Array = [];
			const childDispatchers:Array = [];
			for each (var name:String in names)
			{
				const parentDispatcher:IEventDispatcher = getFromInjector(parentContext.injector, IEventDispatcher, name);
				const childDispatcher:IEventDispatcher = getFromInjector(childContext.injector, IEventDispatcher, name)
				parentDispatchers.push(parentDispatcher);
				childDispatchers.push(childDispatcher);
			}

			assertThat(childDispatchers, array(parentDispatchers));
			UIImpersonator.removeChild(container);
		}
		
		public function getFromInjector(injector:Injector, type:Class, name:String = ""):IEventDispatcher
		{
			if(injector.hasMapping(type, name))
			{
				return injector.getInstance(type, name);
			}
			return null;
		}
	}
}
