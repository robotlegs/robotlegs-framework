//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.modularity.impl
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import org.hamcrest.assertThat;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import robotlegs.bender.extensions.eventCommandMap.support.SupportEvent;
	import robotlegs.bender.extensions.eventDispatcher.EventDispatcherExtension;
	import robotlegs.bender.extensions.modularity.api.IModuleConnector;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.impl.Context;

	public class ModuleConnectorTest
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var parentDispatcher:IEventDispatcher;

		private var childADispatcher:IEventDispatcher;

		private var childBDispatcher:IEventDispatcher;

		private var parentConnector:IModuleConnector;

		private var childAConnector:IModuleConnector;

		private var childBConnector:IModuleConnector;

		/*============================================================================*/
		/* Test Setup and Teardown                                                    */
		/*============================================================================*/

		[Before]
		public function before():void
		{
			const parentContext:IContext = new Context().install(EventDispatcherExtension);
			const childAContext:IContext = new Context().install(EventDispatcherExtension);
			const childBContext:IContext = new Context().install(EventDispatcherExtension);
			
			parentContext.addChild(childAContext);
			parentContext.addChild(childBContext);

			parentConnector = new ModuleConnector(parentContext);
			childAConnector = new ModuleConnector(childAContext);
			childBConnector = new ModuleConnector(childBContext);

			parentDispatcher = parentContext.injector.getInstance(IEventDispatcher);
			childADispatcher = childAContext.injector.getInstance(IEventDispatcher);
			childBDispatcher = childBContext.injector.getInstance(IEventDispatcher);
		}

		/*============================================================================*/
		/* Tests                                                                      */
		/*============================================================================*/

		[Test]
		public function allows_communication_from_parent_to_child():void
		{
			parentConnector.onDefaultChannel()
				.relayEvent(SupportEvent.TYPE1);
			childAConnector.onDefaultChannel()
				.receiveEvent(SupportEvent.TYPE1);

			var wasCalled:Boolean = false;
			childADispatcher.addEventListener(SupportEvent.TYPE1, function(event:Event):void {
				wasCalled = true;
			});

			parentDispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));

			assertThat(wasCalled, isTrue());
		}

		[Test]
		public function allows_communication_from_child_to_parent():void
		{
			parentConnector.onDefaultChannel()
				.receiveEvent(SupportEvent.TYPE1);
			childAConnector.onDefaultChannel()
				.relayEvent(SupportEvent.TYPE1);

			var wasCalled:Boolean = false;
			parentDispatcher.addEventListener(SupportEvent.TYPE1, function(event:Event):void {
				wasCalled = true;
			});

			childADispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));

			assertThat(wasCalled, isTrue());
		}

		[Test]
		public function allows_communication_amongst_children():void
		{
			childAConnector.onDefaultChannel()
				.relayEvent(SupportEvent.TYPE1);
			childBConnector.onDefaultChannel()
				.receiveEvent(SupportEvent.TYPE1);

			var wasCalled:Boolean = false;
			childBDispatcher.addEventListener(SupportEvent.TYPE1, function(event:Event):void {
				wasCalled = true;
			});

			childADispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));

			assertThat(wasCalled, isTrue());
		}

		[Test]
		public function channels_are_isolated():void
		{
			parentConnector.onDefaultChannel()
				.relayEvent(SupportEvent.TYPE1);
			childAConnector.onChannel('other-channel')
				.receiveEvent(SupportEvent.TYPE1);

			var wasCalled:Boolean = false;
			childADispatcher.addEventListener(SupportEvent.TYPE1, function(event:Event):void {
				wasCalled = true;
			});

			parentDispatcher.dispatchEvent(new SupportEvent(SupportEvent.TYPE1));

			assertThat(wasCalled, isFalse());
		}
	}
}
