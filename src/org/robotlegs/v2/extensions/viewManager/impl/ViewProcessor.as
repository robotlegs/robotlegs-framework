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
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.robotlegs.v2.extensions.viewManager.api.IViewHandler;
	import org.robotlegs.v2.extensions.viewManager.api.IViewListener;
	import org.robotlegs.v2.extensions.viewManager.api.ViewHandlerEvent;

	public class ViewProcessor
	{
		private static const logger:ILogger = getLogger(ViewProcessor);

		private const _activeListenerByView:Dictionary = new Dictionary(true);

		private const _confirmedHandlersByFQCN:Dictionary = new Dictionary(false);

		private var _containerRegistry:ContainerRegistry = new ContainerRegistry();

		private const _removeHandlersByView:Dictionary = new Dictionary(true);

		public function ViewProcessor(containerRegistry:ContainerRegistry)
		{
			_containerRegistry = containerRegistry;
			// note: all vectors should probably be linked lists
			// to prevent mid-iteration errors
		}

		public function addHandler(handler:IViewHandler, container:DisplayObjectContainer):void
		{
			_containerRegistry.registerContainer(container).addHandler(handler);
			handler.addEventListener(ViewHandlerEvent.HANDLER_CONFIGURATION_CHANGE, onHandlerConfigurationChange);
			invalidate();
		}

		public function removeHandler(handler:IViewHandler, container:DisplayObjectContainer):void
		{
			const binding:ContainerBinding = _containerRegistry.getBinding(container);
			if (binding)
			{
				binding.removeHandler(handler);
				handler.removeEventListener(ViewHandlerEvent.HANDLER_CONFIGURATION_CHANGE, onHandlerConfigurationChange);
				if (binding.handlers.length == 0)
					_containerRegistry.unregisterContainer(container);
				invalidate();
			}
		}

		public function processView(view:DisplayObject, listener:IViewListener):void
		{
			// multiple listeners might report this view
			// but only the first one that is handled should be responsible for it
			// so bail out if we already have a listener that reported a valid view
			if (_activeListenerByView[view])
				return;

			const viewFQCN:String = getQualifiedClassName(view);

			// process the view
			var confirmedHandlers:Vector.<IViewHandler> = _confirmedHandlersByFQCN[viewFQCN];
			var response:uint;
			if (confirmedHandlers)
			{
				response = processKnownView(view, viewFQCN, confirmedHandlers);
			}
			else
			{
				_confirmedHandlersByFQCN[viewFQCN] = confirmedHandlers = new Vector.<IViewHandler>;
				response = processFreshView(view, viewFQCN, confirmedHandlers);
			}

			// report any matches
			if (response)
			{
				// only the listener that gave us this view should wire up removal listeners
				_activeListenerByView[view] = listener;
				listener.onViewProcessed(view);
			}
		}

		public function releaseView(view:DisplayObject):void
		{
			var handler:IViewHandler;
			const handlers:Vector.<IViewHandler> = _removeHandlersByView[view];
			const totalHandlers:uint = handlers.length;
			for (var i:uint = 0; i < totalHandlers; i++)
			{
				handler = handlers[i];
				handler.releaseView(view);
			}
			delete _removeHandlersByView[view];
			const activeListener:IViewListener = _activeListenerByView[view];
			if (activeListener)
			{
				activeListener.onViewReleased(view);
				delete _activeListenerByView[view];
			}
		}

		public function destroy():void
		{
		}

		private function processFreshView(
			view:DisplayObject,
			viewFQCN:String,
			confirmedHandlers:Vector.<IViewHandler>):uint
		{
			var handlerResponse:uint = 0;
			var combinedResponse:uint = 0;
			var handler:IViewHandler;
			var handlers:Vector.<IViewHandler>;
			var binding:ContainerBinding = _containerRegistry.findParentBinding(view);
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

					handlerResponse = handler.processView(view, null);
					combinedResponse |= handlerResponse;

					if (handlerResponse)
					{
						queueRemoveHandler(view, handler);
						confirmedHandlers.push(handler);
					}
				}

				binding = binding.parent;
			}

			return combinedResponse;
		}

		private function processKnownView(
			view:DisplayObject,
			viewFQCN:String,
			confirmedHandlers:Vector.<IViewHandler>):uint
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

				handlerResponse = handler.processView(view, null);
				combinedResponse |= handlerResponse;

				if (handlerResponse)
				{
					queueRemoveHandler(view, handler);
				}
				else
				{
					logger.warn('a confirmed handler did not handle a view - cache purging did not take place when it should have');
				}
			}
			return combinedResponse;
		}

		private function queueRemoveHandler(view:DisplayObject, handler:IViewHandler):void
		{
			const removeHandlers:Vector.<IViewHandler> = _removeHandlersByView[view] ||= new Vector.<IViewHandler>;
			removeHandlers.push(handler);
		}

		private function onHandlerConfigurationChange(event:ViewHandlerEvent):void
		{
			// on binding change event rather? - would allow more fine grained cache invalidation
			invalidate();
		}

		private function invalidate():void
		{
			purgeConfirmedHandlerCache();
		}

		private function purgeConfirmedHandlerCache():void
		{
			logger.warn('the confirmed handler cache has been purged. This is normal, but if you see this message too often something might be wrong');
			for (var key:Object in _confirmedHandlersByFQCN)
			{
				delete _confirmedHandlersByFQCN[key];
			}
		}
	}
}
