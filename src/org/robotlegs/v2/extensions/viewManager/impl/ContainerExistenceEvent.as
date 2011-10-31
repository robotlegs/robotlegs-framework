//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.viewManager.impl
{
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;

	public class ContainerExistenceEvent extends Event
	{
		public static const CONTAINER_ADD:String = 'containerAdd';

		public static const CONTAINER_REMOVE:String = 'containerRemove';

		public static const ROOT_CONTAINER_ADD:String = 'rootContainerAdd';

		public static const ROOT_CONTAINER_REMOVE:String = 'rootContainerRemove';

		private var _container:DisplayObjectContainer;

		public function get container():DisplayObjectContainer
		{
			return _container;
		}

		public function ContainerExistenceEvent(type:String, container:DisplayObjectContainer)
		{
			super(type);
			_container = container;
		}

		override public function clone():Event
		{
			return new ContainerExistenceEvent(type, _container);
		}
	}
}
