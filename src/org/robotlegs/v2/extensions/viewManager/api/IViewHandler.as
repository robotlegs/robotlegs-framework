//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.viewManager.api
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;

	[Event(name="configurationChange", type="org.robotlegs.v2.extensions.viewManager.api.ViewHandlerEvent")]
	public interface IViewHandler extends IEventDispatcher
	{
		function get interests():uint;

		function processView(view:DisplayObject, info:IViewClassInfo):uint;

		function releaseView(view:DisplayObject):void;

		// can we replace this with [preDestroy] ?
		function destroy():void;
	}
}
