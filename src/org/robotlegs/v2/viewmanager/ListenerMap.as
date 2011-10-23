//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.viewmanager
{
	import flash.events.IEventDispatcher;
	import flash.utils.Dictionary;

	// the event type and handler persist, and we encapsulate
	// the adding and removing of listeners as the list of
	// required targets varies
	public class ListenerMap implements IListenerMap
	{

		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/

		protected var _callback:Function;

		protected var _currentTargets:Dictionary = new Dictionary();

		protected var _eventType:String;

		// change this at your peril unless you understand the situation and have a genius fix
		protected var _useCapture:Boolean = true;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ListenerMap(eventType:String, callback:Function, useCapture:Boolean = true):void
		{
			_eventType = eventType;
			_callback = callback;
			// setting this value to false is nice for testing and for non viewy things.
			_useCapture = useCapture;
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function updateListenerTargets(targets:Vector.<IEventDispatcher>):void
		{
			const oldTargets:Dictionary = _currentTargets;
			_currentTargets = new Dictionary();

			var target:IEventDispatcher;

			const iLength:uint = targets.length;
			for (var i:uint = 0; i < iLength; i++)
			{
				target = targets[i];
				_currentTargets[target] = true;

				if (oldTargets[target])
				{
					delete oldTargets[target];
				}
				else
				{
					target.addEventListener(_eventType, _callback, _useCapture, 0, true);
				}
			}

			removeListenersFrom(oldTargets);
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		protected function removeListenersFrom(oldTargets:Dictionary):void
		{
			for (var target:* in oldTargets)
			{
				(target as IEventDispatcher).removeEventListener(_eventType, _callback, _useCapture);
			}
		}
	}
}
