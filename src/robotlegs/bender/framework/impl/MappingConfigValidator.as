//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import robotlegs.bender.framework.api.MappingConfigError;

	public class MappingConfigValidator
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _valid:Boolean = false;

		public function get valid():Boolean
		{
			return _valid;
		}

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const CANT_CHANGE_GUARDS_AND_HOOKS:String = "You can't change the guards and hooks on an existing mapping. Unmap first.";

		private const STORED_ERROR_EXPLANATION:String = " The stacktrace for this error was stored at the time when you duplicated the mapping - you may have failed to add guards and hooks that were already present.";

		private var _guards:Array;

		private var _hooks:Array;

		private var _trigger:*;

		private var _action:*;

		private var _storedError:MappingConfigError;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function MappingConfigValidator(guards:Array, hooks:Array, trigger:*, action:*)
		{
			_guards = guards;
			_hooks = hooks;

			_trigger = trigger;
			_action = action;

			super();
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function invalidate():void
		{
			_valid = false;
			_storedError = new MappingConfigError(CANT_CHANGE_GUARDS_AND_HOOKS + STORED_ERROR_EXPLANATION, _trigger, _action);
		}

		public function validate(guards:Array, hooks:Array):void
		{
			if ((!arraysMatch(_guards, guards)) || (!arraysMatch(_hooks, hooks)))
				throwStoredError() || throwMappingError();

			_valid = true;
			_storedError = null;
		}

		public function checkGuards(guards:Array):void
		{
			if (changesContent(_guards, guards))
				throwMappingError();
		}

		public function checkHooks(hooks:Array):void
		{
			if (changesContent(_hooks, hooks))
				throwMappingError();
		}

		public function flatten(array:Array):Array
		{
			var flattened:Array = [];
			for each (var obj:* in array)
			{
				if (obj is Array)
				{
					flattened = flattened.concat(flatten(obj as Array))
				}
				else
				{
					flattened.push(obj)
				}
			}
			return flattened
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function changesContent(current:Array, proposed:Array):Boolean
		{
			proposed = flatten(proposed);

			for each (var item:* in proposed)
			{
				if (current.indexOf(item) == -1)
					return true;
			}
			return false;
		}

		private function arraysMatch(arr1:Array, arr2:Array):Boolean
		{
			arr1 = arr1.slice();

			if (arr1.length != arr2.length)
				return false;

			var foundAtIndex:int;

			const iLength:uint = arr2.length;
			for (var i:uint = 0; i < iLength; i++)
			{
				foundAtIndex = arr1.indexOf(arr2[i]);
				if (foundAtIndex == -1)
					return false;

				arr1.splice(foundAtIndex, 1);
			}

			return true;
		}

		private function throwMappingError():void
		{
			throw(new MappingConfigError(CANT_CHANGE_GUARDS_AND_HOOKS, _trigger, _action));
		}

		private function throwStoredError():Boolean
		{
			if (_storedError)
				throw _storedError;
			return false;
		}
	}
}
