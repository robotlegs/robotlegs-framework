//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.hooks.impl
{
	import flash.utils.Dictionary;
	import robotlegs.bender.core.utilities.classHasMethod;
	import robotlegs.bender.core.utilities.pushValuesToClassVector;
	import robotlegs.bender.core.utilities.removeValuesFromClassVector;
	import robotlegs.bender.extensions.hooks.api.IHookGroup;
	import org.swiftsuspenders.Injector;

	// TODO: move out of extensions and into core
	public class HookGroup implements IHookGroup
	{
		private const _verifiedHookClasses:Dictionary = new Dictionary();

		private const _hookClasses:Vector.<Class> = new Vector.<Class>;

		private var _injector:Injector;

		public function HookGroup(injector:Injector)
		{
			_injector = injector;
		}

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
				var hook:* = _injector.getInstance(hookClass);
				hook.hook();
			}
		}

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
