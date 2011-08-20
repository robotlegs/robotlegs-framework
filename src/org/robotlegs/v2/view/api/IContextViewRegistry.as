//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.view.api
{
	import flash.display.DisplayObjectContainer;
	import org.robotlegs.v2.context.api.IContext;

	public interface IContextViewRegistry
	{
		function addContext(context:IContext):void;

		function getContexts(view:DisplayObjectContainer):Vector.<IContext>;

		function removeContext(context:IContext):void;
	}
}
