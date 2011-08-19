//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.view.api
{
	import flash.display.DisplayObject;
	import org.robotlegs.v2.view.restricted.ViewHandlerResponse;

	public interface IViewHandler
	{
		function addView(view:DisplayObject, className:String):ViewHandlerResponse;

		function removeView(view:DisplayObject, className:String):ViewHandlerResponse;
	}
}
