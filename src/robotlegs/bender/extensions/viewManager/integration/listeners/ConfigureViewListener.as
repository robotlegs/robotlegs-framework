//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.integration.listeners
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import robotlegs.bender.extensions.viewManager.api.IViewListener;
	import robotlegs.bender.extensions.viewManager.impl.ContainerBinding;
	import robotlegs.bender.extensions.viewManager.impl.ContainerExistenceEvent;
	import robotlegs.bender.extensions.viewManager.impl.ContainerRegistry;
	import robotlegs.bender.extensions.viewManager.impl.ViewProcessor;

	public class ConfigureViewListener implements IViewListener
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _containerRegistry:ContainerRegistry;

		private var _viewProcessor:ViewProcessor;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ConfigureViewListener(
			viewProcessor:ViewProcessor,
			containerRegistry:ContainerRegistry)
		{
			_containerRegistry = containerRegistry;
			_viewProcessor = viewProcessor;
			// We care about all containers (not just roots)
			_containerRegistry.addEventListener(ContainerExistenceEvent.CONTAINER_ADD, onBindingRegister);
			_containerRegistry.addEventListener(ContainerExistenceEvent.CONTAINER_REMOVE, onBindingUnregister);
			// We might have arrived late on the scene
			for each (var binding:ContainerBinding in _containerRegistry.bindings)
			{
				addContainerListeners(binding.container);
			}
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function destroy():void
		{
			// We just don't care any more
			_containerRegistry.removeEventListener(ContainerExistenceEvent.CONTAINER_ADD, onBindingRegister);
			_containerRegistry.removeEventListener(ContainerExistenceEvent.CONTAINER_REMOVE, onBindingUnregister);
			// We must say goodbye properly
			for each (var binding:ContainerBinding in _containerRegistry.bindings)
			{
				removeContainerListeners(binding.container);
			}
		}

		public function onViewProcessed(view:DisplayObject):void
		{
			// Listen directly to target for removal
			view.addEventListener(Event.REMOVED_FROM_STAGE, onViewRemovedFromStage);
		}

		public function onViewReleased(view:DisplayObject):void
		{
			// Release the target removal listener
			view.removeEventListener(Event.REMOVED_FROM_STAGE, onViewRemovedFromStage);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function addContainerListeners(container:DisplayObjectContainer):void
		{
			// We're interested in ALL container bindings
			// but just for normal, bubbling events
			container.addEventListener(ConfigureViewEvent.CONFIGURE_VIEW, onConfigureView, false);
		}

		private function removeContainerListeners(container:DisplayObjectContainer):void
		{
			// Release the container listener
			container.addEventListener(ConfigureViewEvent.CONFIGURE_VIEW, onConfigureView, false);
		}

		private function onBindingRegister(event:ContainerExistenceEvent):void
		{
			addContainerListeners(event.container);
		}

		private function onBindingUnregister(event:ContainerExistenceEvent):void
		{
			removeContainerListeners(event.container);
		}

		private function onConfigureView(event:ConfigureViewEvent):void
		{
			// Stop that event!
			// The view processor can handle things from here
			event.stopImmediatePropagation();
			_viewProcessor.processView(event.target as DisplayObject, this);
		}

		private function onViewRemovedFromStage(event:Event):void
		{
			// Tell the view processor to remove this view
			_viewProcessor.releaseView(event.target as DisplayObject);
		}
	}
}
