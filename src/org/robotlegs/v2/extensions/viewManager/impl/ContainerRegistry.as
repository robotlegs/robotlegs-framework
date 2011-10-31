//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.viewManager.impl
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.robotlegs.v2.extensions.viewManager.api.ContainerExistenceEvent;
	import org.robotlegs.v2.extensions.viewManager.api.IContainerBinding;
	import org.robotlegs.v2.extensions.viewManager.api.IContainerRegistry;

	[Event(name="containerAdd", type="org.robotlegs.v2.extensions.viewManager.api.ContainerExistenceEvent")]
	[Event(name="containerRemove", type="org.robotlegs.v2.extensions.viewManager.api.ContainerExistenceEvent")]
	[Event(name="rootContainerAdd", type="org.robotlegs.v2.extensions.viewManager.api.ContainerExistenceEvent")]
	[Event(name="rootContainerRemove", type="org.robotlegs.v2.extensions.viewManager.api.ContainerExistenceEvent")]
	public class ContainerRegistry extends EventDispatcher implements IContainerRegistry
	{
		private static const logger:ILogger = getLogger(ContainerRegistry);

		private const _bindings:Vector.<IContainerBinding> = new Vector.<IContainerBinding>;

		public function get bindings():Vector.<IContainerBinding>
		{
			return _bindings;
		}

		private const _rootBindings:Vector.<IContainerBinding> = new Vector.<IContainerBinding>;

		public function get rootBindings():Vector.<IContainerBinding>
		{
			return _rootBindings;
		}

		private const _bindingByContainer:Dictionary = new Dictionary(false);

		public function getBinding(container:DisplayObjectContainer):IContainerBinding
		{
			return _bindingByContainer[container];
		}

		public function registerContainer(container:DisplayObjectContainer):IContainerBinding
		{
			return _bindingByContainer[container] ||= createBinding(container);
		}

		public function unregisterContainer(container:DisplayObjectContainer):IContainerBinding
		{
			const binding:IContainerBinding = _bindingByContainer[container];
			binding && removeBinding(binding);
			return binding;
		}

		public function findParentBinding(target:DisplayObject):IContainerBinding
		{
			var parent:DisplayObjectContainer = target.parent;
			while (parent)
			{
				var binding:IContainerBinding = _bindingByContainer[parent];
				if (binding)
				{
					return binding;
				}
				parent = parent.parent;
			}
			return null;
		}

		private function createBinding(container:DisplayObjectContainer):IContainerBinding
		{
			logger.info('container binding created');

			const binding:IContainerBinding = new ContainerBinding(container);
			_bindings.push(binding);

			// If the new binding doesn't have a parent it is a Root
			binding.parent = findParentBinding(container);
			if (binding.parent == null)
			{
				addRootBinding(binding);
			}

			// Reparent any bindings which are contained within the new binding AND
			// A. Don't have a parent, OR
			// B. Have a parent that is not contained within the new binding
			for each (var childBinding:IContainerBinding in _bindingByContainer)
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

			dispatchEvent(new ContainerExistenceEvent(ContainerExistenceEvent.CONTAINER_ADD, binding.container));
			return binding;
		}

		private function removeBinding(binding:IContainerBinding):void
		{
			logger.info('container binding removed');

			// Remove the binding itself
			delete _bindingByContainer[binding.container];
			const index:int = _bindings.indexOf(binding);
			_bindings.splice(index, 1);

			if (!binding.parent)
			{
				// This binding didn't have a parent, so it was a Root
				removeRootBinding(binding);
			}

			// Re-parent the bindings
			for each (var childBinding:IContainerBinding in _bindingByContainer)
			{
				if (childBinding.parent == binding)
				{
					childBinding.parent = binding.parent;
					if (!childBinding.parent)
					{
						// This binding used to have a parent,
						// but no longer does, so it is now a Root
						addRootBinding(childBinding);
					}
				}
			}

			dispatchEvent(new ContainerExistenceEvent(ContainerExistenceEvent.CONTAINER_REMOVE, binding.container));
		}

		private function addRootBinding(binding:IContainerBinding):void
		{
			logger.info('root container binding added');
			_rootBindings.push(binding);
			dispatchEvent(new ContainerExistenceEvent(ContainerExistenceEvent.ROOT_CONTAINER_ADD, binding.container));
		}

		private function removeRootBinding(binding:IContainerBinding):void
		{
			logger.info('root container binding removed');
			const index:int = _rootBindings.indexOf(binding);
			_rootBindings.splice(index, 1);
			dispatchEvent(new ContainerExistenceEvent(ContainerExistenceEvent.ROOT_CONTAINER_REMOVE, binding.container));
		}
	}
}
