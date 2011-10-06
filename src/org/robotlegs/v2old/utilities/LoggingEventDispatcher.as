//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2old.utilities
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	public class LoggingEventDispatcher extends EventDispatcher
	{

		/*============================================================================*/
		/* Protected Static Properties                                                */
		/*============================================================================*/

		protected static const logger:ILogger = getLogger(LoggingEventDispatcher);

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function LoggingEventDispatcher()
		{
			super();
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

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
