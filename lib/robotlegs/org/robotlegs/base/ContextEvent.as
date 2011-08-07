/*
 * Copyright (c) 2009 the original author or authors
 * 
 * Permission is hereby granted to use, modify, and distribute this file 
 * in accordance with the terms of the license agreement accompanying it.
 */

package org.robotlegs.base
{
	import flash.events.Event;
	
	/**
	 * A framework Event implementation
	 */
	public class ContextEvent extends Event
	{
		public static const STARTUP:String = 'startup';
		public static const STARTUP_COMPLETE:String = 'startupComplete';
		
		public static const SHUTDOWN:String = 'shutdown';
		public static const SHUTDOWN_COMPLETE:String = 'shutdownComplete';
		
		protected var _body:*;
		
		/**
		 * A generic context <code>Event</code> implementation
		 *
		 * <p>This class is handy for prototype work, but it's usage is not considered Best Practice</p>
		 *
		 * @param type The <code>Event</code> type
		 * @param body A loosely typed payload
		 */
		public function ContextEvent(type:String, body:* = null)
		{
			super(type);
			_body = body;
		}
		
		/**
		 * Loosely typed <code>Event</code> payload
		 * @return Payload
		 */
		public function get body():*
		{
			return _body;
		}
		
		override public function clone():Event
		{
			return new ContextEvent(type, body);
		}
	
	}
}