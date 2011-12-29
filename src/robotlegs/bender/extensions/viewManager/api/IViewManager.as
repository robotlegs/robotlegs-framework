//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.api
{
	import flash.display.DisplayObjectContainer;

	public interface IViewManager
	{
		function addContainer(container:DisplayObjectContainer):void;

		function removeContainer(container:DisplayObjectContainer):void;

		function addHandler(handler:IViewHandler):void;

		function removeHandler(handler:IViewHandler):void;

		// can we replace this with [preDestroy] ?
		function destroy():void;
	}
}
