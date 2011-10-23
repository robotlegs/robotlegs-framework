//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.view.api
{
	import flash.display.DisplayObject;

	public interface IViewHandler
	{
		function get interests():uint;

		function handleViewAdded(view:DisplayObject, info:IViewClassInfo):uint;

		function handleViewRemoved(view:DisplayObject):void;

		function register(watcher:IViewWatcher):void;
	}
}
