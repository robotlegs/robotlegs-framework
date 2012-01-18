//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.localEventMap.impl
{
	import flash.events.IEventDispatcher;

	public class EventMapConfig
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _dispatcher:IEventDispatcher;

		public function get dispatcher():IEventDispatcher
		{
			return _dispatcher;
		}

		private var _eventString:String;

		public function get eventString():String
		{
			return _eventString;
		}

		private var _listener:Function;

		public function get listener():Function
		{
			return _listener;
		}

		private var _eventClass:Class;

		public function get eventClass():Class
		{
			return _eventClass;
		}

		private var _callback:Function;

		public function get callback():Function
		{
			return _callback;
		}

		private var _useCapture:Boolean;

		public function get useCapture():Boolean
		{
			return _useCapture;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function EventMapConfig(dispatcher:IEventDispatcher,
			eventString:String,
			listener:Function,
			eventClass:Class,
			callback:Function,
			useCapture:Boolean)
		{
			_dispatcher = dispatcher;
			_eventString = eventString;
			_listener = listener;
			_eventClass = eventClass;
			_callback = callback;
			_useCapture = useCapture;
		}
	}
}
