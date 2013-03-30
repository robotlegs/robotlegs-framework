//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.impl
{
	import flash.utils.Dictionary;
	import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;

	public class CommandTriggerMap
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _triggers:Dictionary = new Dictionary();

		private var _keyFactory:Function;

		private var _triggerFactory:Function;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function CommandTriggerMap(keyFactory:Function, triggerFactory:Function)
		{
			_keyFactory = keyFactory;
			_triggerFactory = triggerFactory;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function getTrigger(... params):ICommandTrigger
		{
			const key:Object = getKey(params);
			return _triggers[key] ||= createTrigger(params);
		}

		public function removeTrigger(... params):ICommandTrigger
		{
			return destroyTrigger(getKey(params));
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function getKey(mapperArgs:Array):Object
		{
			return _keyFactory.apply(null, mapperArgs);
		}

		private function createTrigger(mapperArgs:Array):ICommandTrigger
		{
			return _triggerFactory.apply(null, mapperArgs);
		}

		private function destroyTrigger(key:Object):ICommandTrigger
		{
			const trigger:ICommandTrigger = _triggers[key];
			if (trigger)
			{
				trigger.deactivate();
				delete _triggers[key];
			}
			return trigger;
		}
	}
}
