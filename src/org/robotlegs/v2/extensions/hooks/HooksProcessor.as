//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.hooks
{
	import org.swiftsuspenders.Injector;
	import ArgumentError;
	import flash.utils.describeType;
	
	public class HooksProcessor
	{
		
		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/


		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function HooksProcessor()
		{
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/
		
		public function runHooks(useInjector:Injector, hookClasses:Vector.<Class>):void
		{
			for each (var hookClass:Class in hookClasses)
			{
				if(! (describeType(hookClass).factory.method.(@name == "hook").length() == 1))
				{
					throw new ArgumentError("No hook function found on class " + hookClass);
				}
				var hook:* = useInjector.getInstance(hookClass);
				hook.hook();
			}
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/
		
	}
}