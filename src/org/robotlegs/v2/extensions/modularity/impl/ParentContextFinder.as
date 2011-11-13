//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.modularity.impl
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextLogger;
	import org.robotlegs.v2.core.api.IContextPreProcessor;
	import org.robotlegs.v2.core.api.IContextViewRegistry;
	import org.robotlegs.v2.core.impl.ContextViewRegistry;

	public class ParentContextFinder implements IContextPreProcessor
	{
		private var callback:Function;

		private var context:IContext;

		private var contextView:DisplayObjectContainer;

		private var logger:IContextLogger;

		public function preProcess(context:IContext, callback:Function):void
		{
			logger = context.logger;
			logger.info(this, 'Looking for parent context.');

			if (context.parent)
			{
				logger.info(this, 'Parent has already been set. parent: {0}', [context.parent]);
				finish();
				return;
			}

			if (context.contextView == null)
			{
				logger.info(this, 'No way to find parent for context (no context view)');
				finish();
				return;
			}

			this.context = context;
			this.callback = callback;
			this.contextView = context.contextView;

			const parentContext:IContext = findParentContext();
			if (parentContext)
			{
				logger.info(this, 'Parent context found immediately: {0}', [parentContext]);
				context.parent = parentContext;
				finish();
				return;
			}
			if (contextView.stage)
			{
				logger.info(this, 'No way to find parent for context. ContextView is on stage, but has not parent context.');
				finish();
				return;
			}
			logger.info(this, 'Not yet on stage, waiting for ADDED_TO_STAGE...');
			contextView.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		public function toString():String
		{
			return 'ParentContextFinder';
		}

		private function findParentContext():IContext
		{
			const contextViewRegistry:IContextViewRegistry = ContextViewRegistry.getSingleton();
			var parent:DisplayObjectContainer = contextView.parent;
			var contexts:Vector.<IContext>;
			while (parent)
			{
				contexts = contextViewRegistry.getContexts(parent);
				if (contexts && contexts.length > 0)
				{
					return contexts[0];
				}
				parent = parent.parent;
			}
			return null;
		}

		private function onAddedToStage(event:Event):void
		{
			logger.info(this, 'Added to stage event caught, looking for parent context.');
			contextView.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			const parentContext:IContext = findParentContext();
			if (parentContext)
			{
				logger.info(this, 'Found parent {0}', [parentContext]);
				context.parent = parentContext;
				finish();
				return;
			}
			logger.info(this, 'No parent found.');
			finish();
		}

		private function finish():void
		{
			logger.info(this, 'Finished. Continuing build.');
			callback();
		}
	}
}
