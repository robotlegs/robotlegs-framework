//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.impl
{
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediator;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import org.robotlegs.v2.extensions.eventMap.api.IEventMap;

	public class Mediator implements IMediator
	{
		[Inject]
		public var eventMap:IEventMap;
		
		protected var _viewComponent:Object;
		protected var _destroyed:Boolean;
		protected var _eventDispatcher:IEventDispatcher;
		
		public function Mediator()
		{
		}

		public function initialize():void
		{
		}

		public function destroy():void
		{
		}
		
		/**
		 * @inheritDoc
		 */
		public function get eventDispatcher():IEventDispatcher
		{
			return _eventDispatcher;
		}
		
		[Inject]
		/**
		 * @private
		 */
		public function set eventDispatcher(value:IEventDispatcher):void
		{
			_eventDispatcher = value;
		}

		public function getViewComponent():Object
		{
			return _viewComponent;
		}

		public function setViewComponent(viewComponent:Object):void
		{
			_viewComponent = viewComponent;
			_viewComponent.addEventListener(Event.REMOVED_FROM_STAGE, suspendEventMap);
			_viewComponent.addEventListener(Event.ADDED_TO_STAGE, resumeEventMap);
		}

		public function get destroyed():Boolean
		{
			return _destroyed;
		}
		
		public function set destroyed(value:Boolean):void
		{
			_destroyed = value;
		}
		
		protected function suspendEventMap(e:Event):void
		{
			eventMap.suspend();
		}
		
		protected function resumeEventMap(e:Event):void
		{
			eventMap.resume();
		}
		
		protected function addViewListener(eventString:String, listener:Function, eventClass:Class):void
		{
			eventMap.mapListener(IEventDispatcher(_viewComponent), eventString, listener, eventClass);
		}
		
		protected function addContextListener(eventString:String, listener:Function, eventClass:Class):void
		{
			eventMap.mapListener(_eventDispatcher, eventString, listener, eventClass);
		}
		
		protected function removeViewListener(eventString:String, listener:Function, eventClass:Class):void
		{
			eventMap.unmapListener(IEventDispatcher(_viewComponent), eventString, listener, eventClass);
		}
		
		protected function removeContextListener(eventString:String, listener:Function, eventClass:Class):void
		{
			eventMap.unmapListener(_eventDispatcher, eventString, listener, eventClass);
		}
		
		protected function dispatch(e:Event):void
		{
			if(eventDispatcher.hasEventListener(e.type))
				eventDispatcher.dispatchEvent(e);
		}
	}
}