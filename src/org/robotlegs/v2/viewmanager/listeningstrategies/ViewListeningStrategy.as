//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.viewmanager.listeningstrategies
{
	import flash.display.DisplayObjectContainer;

	public class ViewListeningStrategy
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		protected var _targets:Vector.<DisplayObjectContainer>;

		public function get targets():Vector.<DisplayObjectContainer>
		{
			return _targets || new Vector.<DisplayObjectContainer>();
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ViewListeningStrategy(targets:Vector.<DisplayObjectContainer>)
		{
			_targets = targets;
		}
	}
}
