//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.viewmanager.listeningstrategies
{
	import flash.display.DisplayObjectContainer;
	import org.robotlegs.v2.viewmanager.IListeningStrategy;

	public class ManualViewListeningStrategy extends ViewListeningStrategy implements IListeningStrategy
	{

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ManualViewListeningStrategy(targets:Vector.<DisplayObjectContainer>)
		{
			super(targets);
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function updateTargets(value:Vector.<DisplayObjectContainer>):Boolean
		{
			// do nothing and always return false, as we don't accept change around here!
			return false;
		}
	}
}
