//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.viewmanager
{
	import flash.display.DisplayObjectContainer;

	public interface IContainerBinding
	{

		function get container():DisplayObjectContainer;
		function get parent():IContainerBinding;

		function set parent(value:IContainerBinding):void;

		function remove():IContainerBinding;
	}
}
