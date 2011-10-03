//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.view.api
{
	import flash.display.DisplayObjectContainer;

	public interface IViewManager
	{
		function addContainer(container:DisplayObjectContainer):void;
		function addHandler(handler:IViewHandler):void;
	}
}
