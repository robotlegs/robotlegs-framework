//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.api
{
	import flash.display.DisplayObject;
	import org.robotlegs.v2.core.api.ITypeMatcher;

	public interface IMediatorMap
	{

		function getMapping(viewTypeOrMatcher:*):IMediatorMapping;

		function hasMapping(viewTypeOrMatcher:*):Boolean;

		function mapMatcher(typeMatcher:ITypeMatcher):IMediatorMapping;

		function map(viewType:Class):IMediatorMapping;

		function unmap(viewType:Class):IMediatorUnmapping;
		
		function unmapMatcher(typeMatcher:ITypeMatcher):IMediatorUnmapping;

		function loadTrigger(trigger:IMediatorTrigger):void;

		function invalidate():void;

		function mediate(object:DisplayObject):Boolean;

		function unmediate(object:DisplayObject):void;
	}
}