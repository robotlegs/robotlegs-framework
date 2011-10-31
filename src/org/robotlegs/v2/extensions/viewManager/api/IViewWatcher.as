//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.viewManager.api
{
	import flash.display.DisplayObject;
	import org.robotlegs.v2.extensions.viewManager.impl.ViewProcessor;

	public interface IViewWatcher
	{
		function configure(viewProcessor:ViewProcessor):void;

		function onViewProcessed(view:DisplayObject):void;

		function onViewReleased(view:DisplayObject):void;

		function destroy():void;
	}
}
