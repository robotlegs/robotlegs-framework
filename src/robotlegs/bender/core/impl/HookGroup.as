//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.core.impl
{
	import flash.utils.Dictionary;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.core.api.IHookGroup;
	import robotlegs.bender.core.utilities.classHasMethod;
	import robotlegs.bender.core.utilities.pushValuesToClassVector;
	import robotlegs.bender.core.utilities.removeValuesFromClassVector;

	public class HookGroup implements IHookGroup
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _verifiedHookClasses:Dictionary = new Dictionary();

		private const _hookClasses:Vector.<Class> = new Vector.<Class>;

		private var _injector:Injector;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function HookGroup(injector:Injector)
		{
			_injector = injector;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function add(... hookClasses):void
		{
			pushValuesToClassVector(hookClasses, _hookClasses);
			verifyHookClasses();
		}

		public function remove(... hookClasses):void
		{
			removeValuesFromClassVector(hookClasses, _hookClasses);
		}

		public function hook():void
		{
			for each (var hookClass:Class in _hookClasses)
			{
				const hook:* = _injector.getInstance(hookClass);
				hook.hook();
			}
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		protected function verifyHookClasses():void
		{
			for each (var hookClass:Class in _hookClasses)
			{
				if (_verifiedHookClasses[hookClass] == undefined)
				{
					_verifiedHookClasses[hookClass] = (classHasMethod(hookClass, 'hook'));
				}
				if (!_verifiedHookClasses[hookClass])
				{
					throw new ArgumentError("No hook function found on class " + hookClass);
				}
			}
		}
	}
}
