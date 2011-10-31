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
	import flash.events.IEventDispatcher;

	[Event(name="containerAdd", type="org.robotlegs.v2.extensions.viewManager.api.ContainerExistenceEvent")]
	[Event(name="containerRemove", type="org.robotlegs.v2.extensions.viewManager.api.ContainerExistenceEvent")]
	[Event(name="rootContainerAdd", type="org.robotlegs.v2.extensions.viewManager.api.ContainerExistenceEvent")]
	[Event(name="rootContainerRemove", type="org.robotlegs.v2.extensions.viewManager.api.ContainerExistenceEvent")]
	public interface IContainerRegistry extends IEventDispatcher
	{
		function get bindings():Vector.<IContainerBinding>;

		function get rootBindings():Vector.<IContainerBinding>;

		function registerContainer(container:DisplayObjectContainer):IContainerBinding;

		function unregisterContainer(container:DisplayObjectContainer):IContainerBinding;

		function findParentBinding(target:DisplayObject):IContainerBinding;

		function getBinding(container:DisplayObjectContainer):IContainerBinding;
	}
}
