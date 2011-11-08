//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.guardsAndHooks.impl
{
	import flash.utils.Dictionary;
	import flash.utils.describeType;
	import org.robotlegs.v2.core.utilities.classHasMethod;
	import org.swiftsuspenders.Injector;
	import org.robotlegs.v2.extensions.guardsAndHooks.api.IHooksProcessor;

	[Deprecated(message="an object with no internal state doesn't deserve to be an object")]
	public class HooksProcessor implements IHooksProcessor
	{

		protected const _verifiedHookClasses:Dictionary = new Dictionary();

		public function HooksProcessor()
		{
		}

		public function runHooks(useInjector:Injector, hookClasses:Vector.<Class>):void
		{
			verifyHookClasses(hookClasses);

			var hook:*;

			for each (var hookClass:Class in hookClasses)
			{
				hook = useInjector.getInstance(hookClass);
				hook.hook();
			}
		}

		protected function verifyHookClasses(hookClasses:Vector.<Class>):void
		{
			for each (var hookClass:Class in hookClasses)
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