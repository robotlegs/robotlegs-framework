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
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	[Event(name="containerAdd", type="robotlegs.bender.extensions.viewManager.impl.ContainerRegistryEvent")]
	[Event(name="containerRemove", type="robotlegs.bender.extensions.viewManager.impl.ContainerRegistryEvent")]
	[Event(name="rootContainerAdd", type="robotlegs.bender.extensions.viewManager.impl.ContainerRegistryEvent")]
	[Event(name="rootContainerRemove", type="robotlegs.bender.extensions.viewManager.impl.ContainerRegistryEvent")]
	/**
	 * @private
	 */
	public class ContainerRegistry extends EventDispatcher
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private const _bindings:Vector.<ContainerBinding> = new Vector.<ContainerBinding>;

		/**
		 * @private
		 */
		public function get bindings():Vector.<ContainerBinding>
		{
			return _bindings;
		}

		private const _rootBindings:Vector.<ContainerBinding> = new Vector.<ContainerBinding>;

		/**
		 * @private
		 */
		public function get rootBindings():Vector.<ContainerBinding>
		{
			return _rootBindings;
		}

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _bindingByContainer:Dictionary = new Dictionary();

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @private
		 */
		public function addContainer(container:DisplayObjectContainer):ContainerBinding
		{
			return _bindingByContainer[container] ||= createBinding(container);
		}

		/**
		 * @private
		 */
		public function removeContainer(container:DisplayObjectContainer):ContainerBinding
		{
			const binding:ContainerBinding = _bindingByContainer[container];
			binding && removeBinding(binding);
			return binding;
		}

		/**
		 * Finds the closest parent binding for a given display object
		 *
		 * @private
		 */
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

		/**
		 * @private
		 */
		public function getBinding(container:DisplayObjectContainer):ContainerBinding
		{
			return _bindingByContainer[container];
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function createBinding(container:DisplayObjectContainer):ContainerBinding
		{
			const binding:ContainerBinding = new ContainerBinding(container);
			_bindings.push(binding);

			// Add a listener so that we can remove this binding when it has no handlers
			binding.addEventListener(ContainerBindingEvent.BINDING_EMPTY, onBindingEmpty);

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

			dispatchEvent(new ContainerRegistryEvent(ContainerRegistryEvent.CONTAINER_ADD, binding.container));
			return binding;
		}

		private function removeBinding(binding:ContainerBinding):void
		{
			// Remove the binding itself
			delete _bindingByContainer[binding.container];
			const index:int = _bindings.indexOf(binding);
			_bindings.splice(index, 1);

			// Drop the empty binding listener
			binding.removeEventListener(ContainerBindingEvent.BINDING_EMPTY, onBindingEmpty);

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

			dispatchEvent(new ContainerRegistryEvent(ContainerRegistryEvent.CONTAINER_REMOVE, binding.container));
		}

		private function addRootBinding(binding:ContainerBinding):void
		{
			_rootBindings.push(binding);
			dispatchEvent(new ContainerRegistryEvent(ContainerRegistryEvent.ROOT_CONTAINER_ADD, binding.container));
		}

		private function removeRootBinding(binding:ContainerBinding):void
		{
			const index:int = _rootBindings.indexOf(binding);
			_rootBindings.splice(index, 1);
			dispatchEvent(new ContainerRegistryEvent(ContainerRegistryEvent.ROOT_CONTAINER_REMOVE, binding.container));
		}

		private function onBindingEmpty(event:ContainerBindingEvent):void
		{
			removeBinding(event.target as ContainerBinding);
		}
	}
}
