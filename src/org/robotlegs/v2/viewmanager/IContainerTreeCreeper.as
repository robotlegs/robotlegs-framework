//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.viewmanager
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	public interface IContainerTreeCreeper
	{

		function get rootContainerBindings():Vector.<IContainerBinding>;

		function excludeContainer(container:DisplayObjectContainer):IContainerBinding;
		function findParentBindingFor(targetObject:DisplayObject):IContainerBinding;

		function getContainerBindingFor(container:DisplayObjectContainer):IContainerBinding;

		function includeContainer(container:DisplayObjectContainer):IContainerBinding;
	}
}
