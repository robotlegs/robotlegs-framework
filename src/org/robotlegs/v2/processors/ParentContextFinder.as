//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.processors
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import org.robotlegs.v2.context.api.IContext;
	import org.robotlegs.v2.context.api.IContextProcessor;
	import org.robotlegs.v2.view.api.IContextViewRegistry;
	import org.robotlegs.v2.view.impl.ContextViewRegistry;

	public class ParentContextFinder implements IContextProcessor
	{

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
			// the parent is already set, or we have no way of finding it
			if (context.parent || context.contextView == null)
			{
				callback();
				return;
			}

			this.context = context;
			this.callback = callback;
			this.contextView = context.contextView;

			// try to find the parent right now
			const parentContext:IContext = findParentContext();

			if (parentContext)
			{
				// we found a parent, set it and let's get out of here!
				context.parent = parentContext;
				callback();
				return;
			}
			else if (contextView.stage)
			{
				// we didn't find one, and we're already on stage, so there's no parent
				callback();
				return;
			}
			else
			{
				// we didn't find one, but we're not on stage yet, so let's wait and try again
				contextView.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			}
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
			contextView.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			const parentContext:IContext = findParentContext();
			if (parentContext)
			{
				context.parent = parentContext;
			}
			// we either found a parent or we didn't, regardless, it's time to move on
			callback();
		}
	}
}
