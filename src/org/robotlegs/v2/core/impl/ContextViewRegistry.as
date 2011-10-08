//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.core.impl
{
	import flash.display.DisplayObjectContainer;
	import flash.utils.Dictionary;

	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextViewRegistry;

	public class ContextViewRegistry implements IContextViewRegistry
	{

		/*============================================================================*/
		/* Protected Static Properties                                                */
		/*============================================================================*/

		protected static var _global:IContextViewRegistry;


		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected const contextsByView:Dictionary = new Dictionary(true);


		/*============================================================================*/
		/* Public Static Functions                                                    */
		/*============================================================================*/

		public static function getSingleton():IContextViewRegistry
		{
			return _global ||= new ContextViewRegistry();
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

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
