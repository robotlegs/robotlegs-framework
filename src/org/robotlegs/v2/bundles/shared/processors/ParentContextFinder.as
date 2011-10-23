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
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextProcessor;
	import org.robotlegs.v2.core.api.IContextViewRegistry;
	import org.robotlegs.v2.core.impl.ContextViewRegistry;

	public class ParentContextFinder implements IContextProcessor
	{

		/*============================================================================*/
		/* Protected Static Properties                                                */
		/*============================================================================*/

		protected static const logger:ILogger = getLogger(ParentContextFinder);


		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected var callback:Function;

		protected var context:IContext;

		protected var contextView:DisplayObjectContainer;


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function process(context:IContext, callback:Function):void
		{
			logger.info('looking for parent of context: {0}', [context]);

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

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

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
			logger.info('added to stage, looking for parent of context: {0}', [context]);
			contextView.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			const parentContext:IContext = findParentContext();
			if (parentContext)
			{
				logger.info('found parent {0} for context {1}', [parentContext, context]);
				context.parent = parentContext;
			}
			else
			{
				logger.info('no parent found for context: {0}', [context]);
			}
			// and.. we're done!
			callback();
		}
	}
}
