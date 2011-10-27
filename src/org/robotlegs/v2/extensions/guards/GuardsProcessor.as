//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.guards
{
	import org.swiftsuspenders.Injector;
	import flash.utils.describeType;

	public class  GuardsProcessor
	{
		
		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/


		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function GuardsProcessor()
		{
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function processGuards(useInjector:Injector, guardClasses:Vector.<Class>):Boolean
		{
			verifyGuardClasses(guardClasses);
			
			var guard:*;
			
			for each (var guardClass:Class in guardClasses)
			{
				guard = useInjector.getInstance(guardClass);
				if(! guard.approve())
					return false;
			}
			
			return true;
		}
		
		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/
		
		protected function verifyGuardClasses(guardClasses:Vector.<Class>):void
		{
			for each (var guardClass:Class in guardClasses)
			{
				if(!(describeType(guardClass).factory.method.(@name == "approve").length() == 1))
				{
					throw new ArgumentError("No approve function found on class " + guardClass);
				}
			}
		}
	}
}