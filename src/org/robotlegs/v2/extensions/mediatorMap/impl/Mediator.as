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
		
		protected var _waitEventString:String;
		protected var _waitEventClass:Class = Event;

		public function Mediator()
		{
		}

		public function preRegister():void
		{
			if(_waitEventString)
			{
				eventMap.mapListener(IEventDispatcher(_viewComponent), _waitEventString, runOnRegister, _waitEventClass);
			}
			else
			{
				onRegister();
			}
		}

		public function preRemove():void
		{
			onRemove();
		}

		public function getViewComponent():Object
		{
			return _viewComponent;
		}

		public function setViewComponent(viewComponent:Object):void
		{
			_viewComponent = viewComponent;
		}

		protected function onRegister():void
		{

		}

		protected function onRemove():void
		{

		}
		
		protected function waitForEvent(eventString:String, eventClass:Class):void
		{
			_waitEventString = eventString;
			_waitEventClass = eventClass;
		}
		
		protected function runOnRegister(e:Event):void
		{
			onRegister();
		}
	}
}