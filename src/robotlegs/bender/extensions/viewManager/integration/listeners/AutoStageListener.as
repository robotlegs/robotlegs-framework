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

	public class AutoStageListener implements IViewListener
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _containerRegistry:ContainerRegistry;

		private var _viewProcessor:ViewProcessor;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function AutoStageListener(
			viewProcessor:ViewProcessor,
			containerRegistry:ContainerRegistry)
		{
			_viewProcessor = viewProcessor;
			_containerRegistry = containerRegistry;
			// We only care about roots
			_containerRegistry.addEventListener(ContainerExistenceEvent.ROOT_CONTAINER_ADD, onRootBindingRegister);
			_containerRegistry.addEventListener(ContainerExistenceEvent.ROOT_CONTAINER_REMOVE, onRootBindingUnregister);
			// We might have arrived late on the scene
			for each (var binding:ContainerBinding in _containerRegistry.rootBindings)
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
			_containerRegistry.removeEventListener(ContainerExistenceEvent.ROOT_CONTAINER_ADD, onRootBindingRegister);
			_containerRegistry.removeEventListener(ContainerExistenceEvent.ROOT_CONTAINER_REMOVE, onRootBindingUnregister);
			// We must say goodbye properly
			for each (var binding:ContainerBinding in _containerRegistry.rootBindings)
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
			// The magical, but extremely expensive, capture-phase ADDED_TO_STAGE listener
			// wired to every root container
			container.addEventListener(Event.ADDED_TO_STAGE, onViewAddedToStage, true);
		}

		private function removeContainerListeners(container:DisplayObjectContainer):void
		{
			// Release the root listener
			container.removeEventListener(Event.ADDED_TO_STAGE, onViewAddedToStage, true);
		}

		private function onRootBindingRegister(event:ContainerExistenceEvent):void
		{
			addContainerListeners(event.container);
		}

		private function onRootBindingUnregister(event:ContainerExistenceEvent):void
		{
			removeContainerListeners(event.container);
		}

		private function onViewAddedToStage(event:Event):void
		{
			// Tell the view processor to process this view
			_viewProcessor.processView(event.target as DisplayObject, this);
		}

		private function onViewRemovedFromStage(event:Event):void
		{
			// Tell the view processor to remove this view
			_viewProcessor.releaseView(event.target as DisplayObject);
		}
	}
}
