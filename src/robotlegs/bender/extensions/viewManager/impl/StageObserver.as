//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.impl
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.getQualifiedClassName;

	/**
	 * @private
	 */
	public class StageObserver
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _filter:RegExp = /^mx\.|^spark\.|^flash\./;

		private var _registry:ContainerRegistry;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function StageObserver(containerRegistry:ContainerRegistry)
		{
			_registry = containerRegistry;
			// We only care about roots
			_registry.addEventListener(ContainerRegistryEvent.ROOT_CONTAINER_ADD, onRootContainerAdd);
			_registry.addEventListener(ContainerRegistryEvent.ROOT_CONTAINER_REMOVE, onRootContainerRemove);
			// We might have arrived late on the scene
			for each (var binding:ContainerBinding in _registry.rootBindings)
			{
				addRootListener(binding.container);
			}
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function destroy():void
		{
			_registry.removeEventListener(ContainerRegistryEvent.ROOT_CONTAINER_ADD, onRootContainerAdd);
			_registry.removeEventListener(ContainerRegistryEvent.ROOT_CONTAINER_REMOVE, onRootContainerRemove);
			for each (var binding:ContainerBinding in _registry.rootBindings)
			{
				removeRootListener(binding.container);
			}
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function onRootContainerAdd(event:ContainerRegistryEvent):void
		{
			addRootListener(event.container);
		}

		private function onRootContainerRemove(event:ContainerRegistryEvent):void
		{
			removeRootListener(event.container);
		}

		private function addRootListener(container:DisplayObjectContainer):void
		{
			// The magical, but extremely expensive, capture-phase ADDED_TO_STAGE listener
			container.addEventListener(Event.ADDED_TO_STAGE, onViewAddedToStage, true);
			// Watch the root container itself - nobody else is going to pick it up!
			container.addEventListener(Event.ADDED_TO_STAGE, onContainerRootAddedToStage);
		}

		private function removeRootListener(container:DisplayObjectContainer):void
		{
			container.removeEventListener(Event.ADDED_TO_STAGE, onViewAddedToStage, true);
			container.removeEventListener(Event.ADDED_TO_STAGE, onContainerRootAddedToStage);
		}

		private function onViewAddedToStage(event:Event):void
		{
			const view:DisplayObject = event.target as DisplayObject;
			// Question: would it be worth caching QCNs by view in a weak dictionary,
			// to avoid getQualifiedClassName() cost?
			const qcn:String = getQualifiedClassName(view);
			const filtered:Boolean = _filter.test(qcn);
			if (filtered)
				return;
			const type:Class = view['constructor'];
			// Walk upwards from the nearest binding
			var binding:ContainerBinding = _registry.findParentBinding(view);
			while (binding)
			{
				binding.handleView(view, type);
				binding = binding.parent;
			}
		}

		private function onContainerRootAddedToStage(event:Event):void
		{
			const container:DisplayObjectContainer = event.target as DisplayObjectContainer;
			container.removeEventListener(Event.ADDED_TO_STAGE, onContainerRootAddedToStage);
			const type:Class = container['constructor'];
			const binding:ContainerBinding = _registry.getBinding(container);
			binding.handleView(container, type);
		}
	}
}
