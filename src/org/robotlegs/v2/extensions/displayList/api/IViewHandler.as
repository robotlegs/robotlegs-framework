//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.displayList.api
{
	import flash.display.DisplayObject;
	import flash.events.IEventDispatcher;

	[Event(name="configurationChange", type="org.robotlegs.v2.extensions.displayList.api.ViewHandlerEvent")]
	public interface IViewHandler extends IEventDispatcher
	{
		function get interests():uint;

		function handleViewAdded(view:DisplayObject, info:IViewClassInfo):uint;

		function handleViewRemoved(view:DisplayObject):void;

		function invalidate():void;
	}
}
