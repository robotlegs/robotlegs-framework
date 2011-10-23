//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.viewmanager
{
	import flash.display.DisplayObjectContainer;

	public interface IListeningStrategy
	{
		function get targets():Vector.<DisplayObjectContainer>;

		function updateTargets(value:Vector.<DisplayObjectContainer>):Boolean;
	}
}
