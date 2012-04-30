//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.lifecycle
{
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	public class Lifecycle extends EventDispatcher
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _state:String = LifecycleState.UNINITIALIZED;

		public function get state():String
		{
			return _state;
		}

		private var _target:Object;

		public function get target():Object
		{
			return _target;
		}

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _reversedEventTypes:Dictionary = new Dictionary();

		private var _reversePriority:int;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function Lifecycle(target:Object)
		{
			_target = target;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		override public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void
		{
			priority = modPriority(type, priority);
			super.addEventListener(type, listener, useCapture, priority, useWeakReference);
		}

		/*============================================================================*/
		/* Internal Functions                                                         */
		/*============================================================================*/

		internal function setCurrentState(state:String):void
		{
			if (_state == state)
				return;
			_state = state;

		}

		internal function addReversedEventTypes(... types):void
		{
			for each (var type:String in types)
				_reversedEventTypes[type] = true;
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function modPriority(type:String, priority:int):int
		{
			return (priority == 0 && _reversedEventTypes[type])
				? _reversePriority++
				: priority;
		}
	}
}
