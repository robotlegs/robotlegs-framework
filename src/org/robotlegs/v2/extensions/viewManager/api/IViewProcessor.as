//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.viewManager.api
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public interface IViewProcessor
	{
		function addHandler(handler:IViewHandler, container:DisplayObjectContainer):void;

		function removeHandler(handler:IViewHandler, container:DisplayObjectContainer):void;

		function processView(view:DisplayObject, watcher:IViewWatcher):void;

		function releaseView(view:DisplayObject):void;
	}
}
