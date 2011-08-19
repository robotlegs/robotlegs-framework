//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.view.api
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public interface IDisplayList
	{
		function get rootContainerBinding():IContainerBinding;

		function bindContainer(container:DisplayObjectContainer):IContainerBinding;

		function findParentBinding(view:DisplayObject):IContainerBinding;

		function getBinding(container:DisplayObjectContainer):IContainerBinding;

		function unbindContainer(container:DisplayObjectContainer):IContainerBinding;
	}
}
