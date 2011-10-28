//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap
{
	import org.robotlegs.v2.view.api.IViewHandler;
	import flash.display.DisplayObject;
	import org.robotlegs.v2.view.api.IViewClassInfo;
	import org.robotlegs.v2.view.api.IViewWatcher;
	
	public class  MediatorMap implements IViewHandler
	{
		
		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/


		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function MediatorMap()
		{
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function get interests():uint
		{
			return 0;
		}

		public function handleViewAdded(view:DisplayObject, info:IViewClassInfo):uint
		{
			return 0;
		}

		public function handleViewRemoved(view:DisplayObject):void
		{
	
		}

		public function register(watcher:IViewWatcher):void
		{
	
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/
		
	}
}