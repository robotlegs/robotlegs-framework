//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.impl
{
	import robotlegs.bender.extensions.viewProcessorMap.dsl.IViewProcessorMapping;

	public interface IViewProcessorViewHandler
	{
		function addMapping(mapping:IViewProcessorMapping):void;

		function removeMapping(mapping:IViewProcessorMapping):void;

		function processItem(item:Object, type:Class):void;

		function unprocessItem(item:Object, type:Class):void;
	}
}
