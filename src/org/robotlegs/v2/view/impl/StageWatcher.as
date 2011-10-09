//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.view.impl
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.utils.Dictionary;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.robotlegs.v2.view.api.IContainerBinding;
	import org.robotlegs.v2.view.api.IViewHandler;
	import org.robotlegs.v2.view.api.IViewWatcher;

	public class StageWatcher implements IViewWatcher
	{

		/*============================================================================*/
		/* Private Static Properties                                                  */
		/*============================================================================*/

		private static const logger:ILogger = getLogger(StageWatcher);


		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _bindingsByContainer:Dictionary = new Dictionary(false);

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function StageWatcher()
		{
			// This page intentionally left blank
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function addHandler(handler:IViewHandler, container:DisplayObjectContainer):void
		{
			if (handler.interests == 0)
				throw new ArgumentError('A view handler must be interested in something.');

			const binding:IContainerBinding = _bindingsByContainer[container] ||= createBindingFor(container);
			binding.addHandler(handler);
		}

		public function removeHandler(handler:IViewHandler, container:DisplayObjectContainer):void
		{
			const binding:IContainerBinding = _bindingsByContainer[container];
			if (!binding)
				return;

			binding.removeHandler(handler);

			if (!binding.hasHandlers())
				removeBinding(binding);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function addRootBinding(binding:IContainerBinding):void
		{
			binding.container.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, true);
			// todo: refactor: don't add a listener for REMOVED_FROM_STAGE, add target listener directly to handled views
			binding.container.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, true);
		}

		private function createBindingFor(container:DisplayObjectContainer):IContainerBinding
		{
			const binding:IContainerBinding = new ContainerBinding(container);
			binding.parent = findParentBindingFor(container);

			// If the new binding doesn't have a parent it is a Root
			if (binding.parent == null)
			{
				addRootBinding(binding);
			}

			// Reparent any bindings which are contained within the new binding AND
			// A. Don't have a parent, OR
			// B. Have a parent that is not contained within the new binding
			for each (var childBinding:IContainerBinding in _bindingsByContainer)
			{
				if (container.contains(childBinding.container))
				{
					if (!childBinding.parent)
					{
						removeRootBinding(childBinding);
						childBinding.parent = binding;
					}
					else if (!container.contains(childBinding.parent.container))
					{
						childBinding.parent = binding;
					}
				}
			}

			return binding;
		}

		private function findParentBindingFor(target:DisplayObject):IContainerBinding
		{
			var parent:DisplayObjectContainer = target.parent;
			while (parent)
			{
				var binding:IContainerBinding = _bindingsByContainer[parent];
				if (binding)
				{
					return binding;
				}
				parent = parent.parent;
			}
			return null;
		}

		private function onAddedToStage(event:Event):void
		{
			const target:DisplayObject = event.target as DisplayObject;

			var handler:IViewHandler;
			var handlers:Vector.<IViewHandler>;
			var binding:IContainerBinding = findParentBindingFor(target);
			while (binding)
			{
				handlers = binding.handlers;
				var totalHandlers:int = handlers.length;
				for (var i:int = 0; i < totalHandlers; i++)
				{
					handler = handlers[i];
					handler.handleViewAdded(target, null);
				}

				binding = binding.parent;
			}
		}

		private function onRemovedFromStage(event:Event):void
		{
			const target:DisplayObject = event.target as DisplayObject;

			var handler:IViewHandler;
			var handlers:Vector.<IViewHandler>;
			var binding:IContainerBinding = findParentBindingFor(target);
			while (binding)
			{
				handlers = binding.handlers;
				var totalHandlers:int = handlers.length;
				for (var i:int = 0; i < totalHandlers; i++)
				{
					handler = handlers[i];
					handler.handleViewRemoved(target);
				}

				binding = binding.parent;
			}
		}

		private function removeBinding(binding:IContainerBinding):void
		{
			delete _bindingsByContainer[binding.container];

			// If the old binding doesn't have a parent it was a Root
			if (!binding.parent)
			{
				removeRootBinding(binding);
			}

			for each (var childBinding:IContainerBinding in _bindingsByContainer)
			{
				if (childBinding.parent == binding)
				{
					childBinding.parent = binding.parent;
					if (!childBinding.parent)
					{
						addRootBinding(childBinding);
					}
				}
			}
		}

		private function removeRootBinding(binding:IContainerBinding):void
		{
			binding.container.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage, true);
			// TODO: refactor - see note in addRootBinding
			binding.container.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage, true);
		}
	}
}
