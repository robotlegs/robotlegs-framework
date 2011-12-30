//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.modularity.impl
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import robotlegs.bender.core.api.IContext;
	import robotlegs.bender.core.api.IContextLogger;
	import robotlegs.bender.core.api.IContextPreProcessor;
	import robotlegs.bender.core.api.IContextViewRegistry;
	import robotlegs.bender.core.impl.ContextViewRegistry;

	public class ParentContextFinder implements IContextPreProcessor
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var callback:Function;

		private var context:IContext;

		private var contextView:DisplayObjectContainer;

		private var logger:IContextLogger;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function preProcess(context:IContext, callback:Function):void
		{
			this.context = context;
			this.callback = callback;
			this.contextView = context.contextView;
			this.logger = context.logger;
			start();
		}

		public function toString():String
		{
			return 'ParentContextFinder';
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function start():void
		{
			logger.info(this, 'Looking for parent context.');

			if (context.parent)
			{
				logger.info(this, 'Parent has already been set. parent: {0}', [context.parent]);
				finish();
				return;
			}

			if (context.contextView == null)
			{
				logger.info(this, 'No way to find parent for context (no context view).');
				finish();
				return;
			}

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
				logger.info(this, 'No way to find parent for context. ContextView is already on stage, but has no parent context.');
				finish();
				return;
			}
			logger.info(this, 'Not yet on stage, waiting for ADDED_TO_STAGE...');
			contextView.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
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

		private function finish():void
		{
			logger.info(this, 'Finished looking. Continuing build.');
			callback();
		}
	}
}
