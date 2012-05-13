//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.api
{
	import flash.display.DisplayObjectContainer;
	import flash.events.IEventDispatcher;

	[Event(name="containerAdd", type="robotlegs.bender.extensions.viewManager.impl.ViewManagerEvent")]
	[Event(name="containerRemove", type="robotlegs.bender.extensions.viewManager.impl.ViewManagerEvent")]
	[Event(name="handlerAdd", type="robotlegs.bender.extensions.viewManager.impl.ViewManagerEvent")]
	[Event(name="handlerRemove", type="robotlegs.bender.extensions.viewManager.impl.ViewManagerEvent")]
	public interface IViewManager extends IEventDispatcher
	{

		function get containers():Vector.<DisplayObjectContainer>;

		function addContainer(container:DisplayObjectContainer):void;

		function removeContainer(container:DisplayObjectContainer):void;

		function addViewHandler(handler:IViewHandler):void;

		function removeViewHandler(handler:IViewHandler):void;

		function removeAllHandlers():void;
	}
}
