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
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.context.impl.Context;
	import robotlegs.bender.framework.object.managed.impl.ManagedObject;

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
			var actual:Object;
			context.require(new ScopedEventDispatcherExtension(name));
			context.addStateHandler(ManagedObject.SELF_INITIALIZE, function():void {
				actual = context.injector.getInstance(IEventDispatcher, name);
			});
			context.initialize();
			assertThat(actual, instanceOf(IEventDispatcher));
		}

		[Test]
		public function named_EventDispatchers_are_mapped_into_injector():void
		{
			const names:Array = ['global', 'other', 'name'];
			const dispatchers:Array = [];
			const context:IContext = new Context();
			context.require(new ScopedEventDispatcherExtension('global', 'other', 'name'));
			context.addStateHandler(ManagedObject.SELF_INITIALIZE, function():void {
				for each (var name:String in names)
				{
					dispatchers.push(context.injector.getInstance(IEventDispatcher, name));
				}
			});
			context.initialize();
			assertThat(dispatchers.length, equalTo(3));
		}

		[Test(async, ui)]
		public function event_dispatchers_are_inherited():void
		{
			const names:Array = ['global', 'other', 'name'];
			const container:UIComponent = new UIComponent();
			const parentView:UIComponent = new UIComponent();
			const childView:UIComponent = new UIComponent();

			const parentContext:IContext = new Context(
				ModularityExtension,
				StageSyncExtension,
				ContextViewExtension,
				parentView,
				new ScopedEventDispatcherExtension('global', 'other', 'name'));

			const childContext:IContext = new Context(
				ModularityExtension,
				StageSyncExtension,
				ContextViewExtension,
				childView,
				new ScopedEventDispatcherExtension('global', 'other', 'name'));

			container.addChild(parentView);
			parentView.addChild(childView);
			UIImpersonator.addChild(container);

			const parentDispatchers:Array = [];
			const childDispatchers:Array = [];
			for each (var name:String in names)
			{
				const parentDispatcher:IEventDispatcher = parentContext.injector.getInstance(IEventDispatcher, name);
				const childDispatcher:IEventDispatcher = childContext.injector.getInstance(IEventDispatcher, name);
				parentDispatchers.push(parentDispatcher)
				childDispatchers.push(childDispatcher)
			}

			assertThat(childDispatchers, array(parentDispatchers));
			UIImpersonator.removeChild(container);
		}
	}
}
