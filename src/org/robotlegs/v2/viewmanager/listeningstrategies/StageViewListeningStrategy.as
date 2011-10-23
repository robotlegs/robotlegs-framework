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

	public class StageViewListeningStrategy extends ViewListeningStrategy implements IListeningStrategy
	{

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function StageViewListeningStrategy(targets:Vector.<DisplayObjectContainer>)
		{
			super(targets);
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function updateTargets(value:Vector.<DisplayObjectContainer>):Boolean
		{
			if (!_targets && value && value.length > 0)
			{
				_targets = new <DisplayObjectContainer>[value[0].stage];
				return true;
			}
			else if (_targets && (!value || value.length == 0))
			{
				_targets = null;
				return true;
			}
			return false;
		}
	}
}
