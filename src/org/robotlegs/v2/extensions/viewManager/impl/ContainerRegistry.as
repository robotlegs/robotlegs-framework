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

	[Event(name="containerAdd", type="org.robotlegs.v2.extensions.viewManager.impl.ContainerExistenceEvent")]
	[Event(name="containerRemove", type="org.robotlegs.v2.extensions.viewManager.impl.ContainerExistenceEvent")]
	[Event(name="rootContainerAdd", type="org.robotlegs.v2.extensions.viewManager.impl.ContainerExistenceEvent")]
	[Event(name="rootContainerRemove", type="org.robotlegs.v2.extensions.viewManager.impl.ContainerExistenceEvent")]
	public class ContainerRegistry extends EventDispatcher
	{
		private static const logger:ILogger = getLogger(ContainerRegistry);

		private const _bindings:Vector.<ContainerBinding> = new Vector.<ContainerBinding>;

		public function get bindings():Vector.<ContainerBinding>
		{
			return _bindings;
		}

		private const _rootBindings:Vector.<ContainerBinding> = new Vector.<ContainerBinding>;

		public function get rootBindings():Vector.<ContainerBinding>
		{
			return _rootBindings;
		}

		private const _bindingByContainer:Dictionary = new Dictionary(false);

		public function getBinding(container:DisplayObjectContainer):ContainerBinding
		{
			return _bindingByContainer[container];
		}

		public function registerContainer(container:DisplayObjectContainer):ContainerBinding
		{
			return _bindingByContainer[container] ||= createBinding(container);
		}

		public function unregisterContainer(container:DisplayObjectContainer):ContainerBinding
		{
			const binding:ContainerBinding = _bindingByContainer[container];
			binding && removeBinding(binding);
			return binding;
		}

		public function findParentBinding(target:DisplayObject):ContainerBinding
		{
			var parent:DisplayObjectContainer = target.parent;
			while (parent)
			{
				var binding:ContainerBinding = _bindingByContainer[parent];
				if (binding)
				{
					return binding;
				}
				parent = parent.parent;
			}
			return null;
		}

		private function createBinding(container:DisplayObjectContainer):ContainerBinding
		{
			logger.info('container binding created');

			const binding:ContainerBinding = new ContainerBinding(container);
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
			for each (var childBinding:ContainerBinding in _bindingByContainer)
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

		private function removeBinding(binding:ContainerBinding):void
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
			for each (var childBinding:ContainerBinding in _bindingByContainer)
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

		private function addRootBinding(binding:ContainerBinding):void
		{
			logger.info('root container binding added');
			_rootBindings.push(binding);
			dispatchEvent(new ContainerExistenceEvent(ContainerExistenceEvent.ROOT_CONTAINER_ADD, binding.container));
		}

		private function removeRootBinding(binding:ContainerBinding):void
		{
			logger.info('root container binding removed');
			const index:int = _rootBindings.indexOf(binding);
			_rootBindings.splice(index, 1);
			dispatchEvent(new ContainerExistenceEvent(ContainerExistenceEvent.ROOT_CONTAINER_REMOVE, binding.container));
		}
	}
}
