//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.core.impl
{
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;
	import robotlegs.bender.core.api.IContext;
	import robotlegs.bender.core.api.IContextViewRegistry;

	public class ContextViewRegistry implements IContextViewRegistry
	{

		protected static var _global:IContextViewRegistry;

		protected const contextsByView:Dictionary = new Dictionary(true);

		public static function getSingleton():IContextViewRegistry
		{
			return _global ||= new ContextViewRegistry();
		}

		public function addContext(context:IContext):void
		{
			const contexts:Vector.<IContext> = contextsByView[context.contextView] ||= new Vector.<IContext>;
			contexts.push(context);
		}

		public function getContexts(view:DisplayObjectContainer):Vector.<IContext>
		{
			return contextsByView[view];
		}

		public function removeContext(context:IContext):void
		{
			const contexts:Vector.<IContext> = getContexts(context.contextView);
			if (contexts)
			{
				const index:int = contexts.indexOf(context);
				if (index != -1)
				{
					contexts.splice(index, 1);
					if (contexts.length == 0)
					{
						delete contextsByView[context.contextView];
					}
				}
			}
		}
	}
}
