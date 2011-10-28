//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.hooks
{
	import org.robotlegs.v2.view.api.IViewClassInfo;
	import flash.display.DisplayObject;
	import org.robotlegs.v2.view.api.IViewWatcher;
	import org.robotlegs.v2.view.api.IViewHandler;
	import org.robotlegs.v2.core.api.ITypeMatcher;
	
	public class ViewHookMap implements IViewHandler
	{
		
		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Inject]
		public var hookMap:HookMap;

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/


		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ViewHookMap()
		{
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function get interests():uint
		{
			return 1;
		}

		public function handleViewAdded(view:DisplayObject, info:IViewClassInfo):uint
		{
			if(hookMap.process(view))
				return 1;
				
			return 0;
		}

		public function handleViewRemoved(view:DisplayObject):void
		{
			// do nothing
		}

		public function register(watcher:IViewWatcher):void
		{
			// TODO - what goes here?
		}
		
		public function map(type:Class):GuardsAndHooksConfig
		{
			return hookMap.map(type);
		}
		
		public function mapMatcher(matcher:ITypeMatcher):GuardsAndHooksConfig
		{
			return hookMap.mapMatcher(matcher);
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/
		
		
		
	}
}