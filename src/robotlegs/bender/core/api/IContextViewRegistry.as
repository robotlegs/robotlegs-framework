//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.core.api
{
	import flash.display.DisplayObjectContainer;

	public interface IContextViewRegistry
	{
		function addContext(context:IContext):void;

		function getContexts(view:DisplayObjectContainer):Vector.<IContext>;

		function removeContext(context:IContext):void;
	}
}
