//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.api
{
	import robotlegs.bender.extensions.viewManager.api.IViewHandler;

	public interface IMediatorViewHandler extends IViewHandler
	{
		function addMapping(mapping:IMediatorMapping):void;

		function removeMapping(mapping:IMediatorMapping):void;
		
		function handleItem(item:Object, type:Class):void;
	}
}
