//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.guards.impl
{
	import flash.utils.Dictionary;
	import org.robotlegs.v2.core.utilities.classHasMethod;
	import org.robotlegs.v2.core.utilities.pushValuesToClassVector;
	import org.robotlegs.v2.core.utilities.removeValuesFromClassVector;
	import org.robotlegs.v2.extensions.guards.api.IGuardGroup;
	import org.swiftsuspenders.Injector;

	public class GuardGroup implements IGuardGroup
	{
		private const _verifiedGuardClasses:Dictionary = new Dictionary();

		private const _guardClasses:Vector.<Class> = new Vector.<Class>;

		private var _injector:Injector;

		public function GuardGroup(injector:Injector)
		{
			_injector = injector;
		}

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
				var guard:* = _injector.getInstance(guardClass);
				if (!guard.approve())
					return false;
			}
			return true;
		}

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
