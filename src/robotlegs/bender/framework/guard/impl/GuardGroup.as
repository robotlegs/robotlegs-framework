//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.guard.impl
{
	import flash.utils.Dictionary;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.framework.guard.api.IGuardGroup;
	import robotlegs.bender.framework.utilities.classHasMethod;
	import robotlegs.bender.framework.utilities.pushValuesToClassVector;
	import robotlegs.bender.framework.utilities.removeValuesFromClassVector;

	public class GuardGroup implements IGuardGroup
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _verifiedGuardClasses:Dictionary = new Dictionary();

		private const _guardClasses:Vector.<Class> = new Vector.<Class>;

		private var _injector:Injector;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function GuardGroup(injector:Injector)
		{
			_injector = injector;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function add(... guardClasses):void
		{
			pushValuesToClassVector(guardClasses, _guardClasses);
			verifyGuardClasses(_guardClasses);
		}

		public function remove(... guardClasses):void
		{
			removeValuesFromClassVector(guardClasses, _guardClasses);
		}

		public function approve():Boolean
		{
			for each (var guardClass:Class in _guardClasses)
			{
				const guard:* = _injector.getInstance(guardClass);
				if (!guard.approve())
					return false;
			}
			return true;
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function verifyGuardClasses(guardClasses:Vector.<Class>):void
		{
			for each (var guardClass:Class in _guardClasses)
			{
				if (_verifiedGuardClasses[guardClass] == undefined)
				{
					_verifiedGuardClasses[guardClass] = (classHasMethod(guardClass, 'approve'));
				}
				if (!_verifiedGuardClasses[guardClass])
				{
					throw new ArgumentError("No approve function found on class " + guardClass);
				}
			}
		}
	}
}
