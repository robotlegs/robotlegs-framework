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
	import flash.utils.getQualifiedClassName;
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

		private const _confirmedHandlersByFQCN:Dictionary = new Dictionary(false);

		private const _removeHandlersByTarget:Dictionary = new Dictionary(true);

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

			// No point in a binding with no handlers!
			if (binding.handlers.length == 0)
				removeBinding(binding);
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function addRootBinding(binding:IContainerBinding):void
		{
			// The magical, but extremely expensive, capture-phase ADDED_TO_STAGE listener
			binding.container.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage, true);
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

		private function ensureRemoveHandler(target:DisplayObject, handler:IViewHandler):void
		{
			var removeHandlers:Vector.<IViewHandler> = _removeHandlersByTarget[target];
			if (!removeHandlers)
			{
				removeHandlers = new Vector.<IViewHandler>;
				_removeHandlersByTarget[target] = removeHandlers;
				// Just a normal, target-phase REMOVED_FROM_STAGE listener per target
				target.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
			}
			removeHandlers.push(handler);
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

		private function handleFreshView(
			target:DisplayObject,
			targetFQCN:String,
			confirmedHandlers:Vector.<IViewHandler>):void
		{
			var handlerResponse:uint = 0;
			var combinedResponse:uint = 0;
			var handler:IViewHandler;
			var handlers:Vector.<IViewHandler>;
			var binding:IContainerBinding = findParentBindingFor(target);
			// Walk upwards from the nearest binding
			while (binding)
			{
				handlers = binding.handlers;
				var totalHandlers:uint = handlers.length;
				for (var i:uint = 0; i < totalHandlers; i++)
				{
					handler = handlers[i];

					// Have our interests been blocked by a previous handler?
					// note: this leads to an interesting thought:
					// Should handlers really be able to have multiple interests (as currently implemented)?
					// How does blocking work then?
					if (!((combinedResponse & 0xAAAAAAAA) ^ (handler.interests << 1)))
						continue;

					handlerResponse = handler.handleViewAdded(target, null);
					combinedResponse |= handlerResponse;

					if (handlerResponse)
					{
						ensureRemoveHandler(target, handler);
						confirmedHandlers.push(handler);
					}
				}

				binding = binding.parent;
			}
		}

		private function handleKnownView(
			target:DisplayObject,
			targetFQCN:String,
			confirmedHandlers:Vector.<IViewHandler>):void
		{
			var handlerResponse:uint = 0;
			var combinedResponse:uint = 0;
			var handler:IViewHandler;
			const totalHandlers:uint = confirmedHandlers.length;
			for (var i:uint = 0; i < totalHandlers; i++)
			{
				handler = confirmedHandlers[i];
				if (!((combinedResponse & 0xAAAAAAAA) ^ (handler.interests << 1)))
				{
					logger.warn('a confirmed handler was blocked - cache purging did not take place when it should have');
					continue;
				}

				handlerResponse = handler.handleViewAdded(target, null);
				combinedResponse |= handlerResponse;

				if (handlerResponse)
				{
					ensureRemoveHandler(target, handler);
				}
				else
				{
					logger.warn('a confirmed handler did not handle a view - cache purging did not take place when it should have');
				}
			}
		}

		private function onAddedToStage(event:Event):void
		{
			const target:DisplayObject = event.target as DisplayObject;
			const targetFQCN:String = getQualifiedClassName(target);

			// note: all vectors should actually be linked lists
			// to prevent mid-iteration errors
			var confirmedHandlers:Vector.<IViewHandler> = _confirmedHandlersByFQCN[targetFQCN];

			if (confirmedHandlers)
			{
				handleKnownView(target, targetFQCN, confirmedHandlers);
			}
			else
			{
				confirmedHandlers = new Vector.<IViewHandler>;
				_confirmedHandlersByFQCN[targetFQCN] = confirmedHandlers;
				handleFreshView(target, targetFQCN, confirmedHandlers);
			}
		}

		private function onRemovedFromStage(event:Event):void
		{
			// This listener only fires for targets that got picked up by handlers
			const target:DisplayObject = event.target as DisplayObject;
			target.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			var handler:IViewHandler;
			const handlers:Vector.<IViewHandler> = _removeHandlersByTarget[target];
			const totalHandlers:uint = handlers.length;
			for (var i:uint = 0; i < totalHandlers; i++)
			{
				handler = handlers[i];
				handler.handleViewRemoved(target);
			}
			delete _removeHandlersByTarget[target];
		}

		private function removeBinding(binding:IContainerBinding):void
		{
			delete _bindingsByContainer[binding.container];

			if (!binding.parent)
			{
				// This binding didn't have a parent, so it was a Root
				removeRootBinding(binding);
			}

			// Re-parent the bindings
			for each (var childBinding:IContainerBinding in _bindingsByContainer)
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
		}

		private function removeRootBinding(binding:IContainerBinding):void
		{
			binding.container.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage, true);
		}
	}
}
