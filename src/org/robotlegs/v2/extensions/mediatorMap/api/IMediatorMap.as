//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.api
{
	import flash.display.DisplayObject;

	public interface IMediatorMap
	{

		function getMapping(mediatorType:Class):IMediatorMapping;

		function hasMapping(mediatorType:Class):Boolean;

		function map(mediatorType:Class):IMediatorMapping;

		function unmap(mediatorType:Class):IMediatorUnmapping;

		function loadTrigger(trigger:IMediatorTrigger):void;

		function invalidate():void;

		function mediate(object:DisplayObject):Boolean;

		function unmediate(object:DisplayObject):void;
	}
}
