//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.core.api
{

	public interface ILogTarget
	{
		function get level():uint;

		function set level(value:uint):void;

		function log(name:String, level:uint, time:Number, message:*, parameters:Array = null):void;
	}
}
