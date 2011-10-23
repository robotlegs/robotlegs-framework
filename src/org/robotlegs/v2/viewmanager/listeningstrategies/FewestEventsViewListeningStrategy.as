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

	public class FewestEventsViewListeningStrategy extends ViewListeningStrategy implements IListeningStrategy
	{

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function FewestEventsViewListeningStrategy(targets:Vector.<DisplayObjectContainer>)
		{
			super(targets);
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function updateTargets(value:Vector.<DisplayObjectContainer>):Boolean
		{
			var oldTargets:Vector.<DisplayObjectContainer> = _targets;
			_targets = value;

			return areDifferentVectorsIgnoringOrder(_targets, oldTargets);
		}
	}
}
