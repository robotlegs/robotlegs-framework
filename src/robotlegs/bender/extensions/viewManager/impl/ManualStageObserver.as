//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.impl
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public class ManualStageObserver
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _registry:ContainerRegistry;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ManualStageObserver(containerRegistry:ContainerRegistry)
		{
			_registry = containerRegistry;
			// We care about all containers (not just roots)
			_registry.addEventListener(ContainerRegistryEvent.CONTAINER_ADD, onContainerAdd);
			_registry.addEventListener(ContainerRegistryEvent.CONTAINER_REMOVE, onContainerRemove);
			// We might have arrived late on the scene
			for each (var binding:ContainerBinding in _registry.bindings)
			{
				addContainerListener(binding.container);
			}
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function destroy():void
		{
			_registry.removeEventListener(ContainerRegistryEvent.CONTAINER_ADD, onContainerAdd);
			_registry.removeEventListener(ContainerRegistryEvent.CONTAINER_REMOVE, onContainerRemove);
			for each (var binding:ContainerBinding in _registry.bindings)
			{
				removeContainerListener(binding.container);
			}
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function onContainerAdd(event:ContainerRegistryEvent):void
		{
			addContainerListener(event.container);
		}

		private function onContainerRemove(event:ContainerRegistryEvent):void
		{
			removeContainerListener(event.container);
		}

		private function addContainerListener(container:DisplayObjectContainer):void
		{
			// We're interested in ALL container bindings
			// but just for normal, bubbling events
			container.addEventListener(ConfigureViewEvent.CONFIGURE_VIEW, onConfigureView);
		}

		private function removeContainerListener(container:DisplayObjectContainer):void
		{
			// Release the container listener
			container.removeEventListener(ConfigureViewEvent.CONFIGURE_VIEW, onConfigureView);
		}

		private function onConfigureView(event:ConfigureViewEvent):void
		{
			// Stop that event!
			event.stopImmediatePropagation();
			const container:DisplayObjectContainer = event.currentTarget as DisplayObjectContainer;
			const view:DisplayObject = event.target as DisplayObject;
			const type:Class = view['constructor'];
			_registry.getBinding(container).handleView(view, type);
		}
	}
}
