//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.bundles.shared.processors
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextPreProcessor;
	import org.robotlegs.v2.core.api.IContextViewRegistry;
	import org.robotlegs.v2.core.api.ILogger;
	import org.robotlegs.v2.core.impl.ContextViewRegistry;
	import org.robotlegs.v2.core.impl.Logger;

	public class ParentContextFinder implements IContextPreProcessor
	{
		protected var callback:Function;

		protected var context:IContext;

		protected var contextView:DisplayObjectContainer;

		protected var logger:ILogger;

		public function preProcess(context:IContext, callback:Function):void
		{
			// we use the context logger for pre processors (for now)
			logger = new Logger(context.id + ' ParentContextFinder', context.logger.target);

			logger.info('looking for parent context');

			if (context.parent)
			{
				logger.info('parent has already been set. parent: {0}', [context.parent]);
				callback();
				return;
			}

			if (context.contextView == null)
			{
				logger.info('no way to find parent for context (no context view)');
				callback();
				return;
			}

			this.context = context;
			this.callback = callback;
			this.contextView = context.contextView;

			const parentContext:IContext = findParentContext();
			if (parentContext)
			{
				logger.info('parent context found immediately: {0}', [parentContext]);
				context.parent = parentContext;
				callback();
				return;
			}
			if (contextView.stage)
			{
				logger.info('no way to find parent for context');
				callback();
				return;
			}
			logger.info('not yet on stage, waiting for ADDED_TO_STAGE...');
			contextView.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		protected function findParentContext():IContext
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

		protected function onAddedToStage(event:Event):void
		{
			logger.info('added to stage, looking for parent context');
			contextView.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			const parentContext:IContext = findParentContext();
			if (parentContext)
			{
				logger.info('found parent {0}', [parentContext]);
				context.parent = parentContext;
			}
			else
			{
				logger.info('no parent found');
			}
			// and.. we're done!
			logger.info('continuing');
			callback();
		}
	}
}
