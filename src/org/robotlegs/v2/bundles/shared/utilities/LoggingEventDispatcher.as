//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.bundles.shared.utilities
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import org.robotlegs.v2.core.api.ILogger;

	public class LoggingEventDispatcher extends EventDispatcher
	{
		private var logger:ILogger;

		public function LoggingEventDispatcher(logger:ILogger)
		{
			super();
			// todo: fixme
			this.logger = logger;
		}

		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			logger.info('Adding listener - type: {0}, useCapture: {1}, priority: {2}, useWeakReference: {3}',
				[type, useCapture, priority, useWeakReference]);
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		override public function dispatchEvent(event:Event):Boolean
		{
			logger.info('Dispatching event: {0}', [event]);
			return super.dispatchEvent(event);
		}

		override public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false):void
		{
			logger.info('Removing listener - type: {0}, useCapture: {1}', [type, useCapture]);
			super.removeEventListener(type, listener, useCapture);
		}
	}
}
