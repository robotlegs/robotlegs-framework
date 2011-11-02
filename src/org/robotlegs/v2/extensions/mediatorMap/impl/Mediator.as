//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.impl
{
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediator;
	import org.robotlegs.core.IEventMap;
	import flash.events.Event;
	import flash.events.IEventDispatcher;

	public class Mediator implements IMediator
	{
		[Inject]
		public var eventMap:IEventMap;
		
		protected var _viewComponent:Object;
		protected var _destroyed:Boolean;
		
		public function Mediator()
		{
		}

		public function initialize():void
		{
		}

		public function destroy():void
		{
		}

		public function getViewComponent():Object
		{
			return _viewComponent;
		}

		public function setViewComponent(viewComponent:Object):void
		{
			_viewComponent = viewComponent;
		}

		public function get destroyed():Boolean
		{
			return _destroyed;
		}
		
		public function set destroyed(value:Boolean):void
		{
			_destroyed = value;
		}
	}
}