//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.eventMap.impl
{
	import flash.events.IEventDispatcher;
	
	public class  EventMapConfig
	{
		protected var _dispatcher:IEventDispatcher;
		protected var _eventString:String;
		protected var _listener:Function;
		protected var _eventClass:Class;
		protected var _callback:Function;
		protected var _useCapture:Boolean;

		public function EventMapConfig(	dispatcher:IEventDispatcher,
										eventString:String,
										listener:Function,
										eventClass:Class,
										callback:Function,
										useCapture:Boolean )
		{
			_dispatcher = dispatcher;
			_eventString = eventString;
			_listener = listener;
			_eventClass = eventClass;
			_callback = callback;
			_useCapture = useCapture;
		}

		public function get dispatcher():IEventDispatcher
		{
			return _dispatcher;
		}
		
		public function get eventString():String
		{
			return _eventString;
		}
		
		public function get listener():Function
		{
			return _listener;
		}
		
		public function get eventClass():Class
		{
			return _eventClass;
		}
		
		public function get callback():Function
		{
			return _callback;
		}
		
		public function get useCapture():Boolean
		{
			return _useCapture;
		}
	}
}