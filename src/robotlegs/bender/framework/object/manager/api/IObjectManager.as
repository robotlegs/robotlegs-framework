//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.object.manager.api
{
	import org.hamcrest.Matcher;
	import robotlegs.bender.framework.object.managed.api.IManagedObject;

	public interface IObjectManager// extends Matcher
	{
		function addObject(object:Object):IManagedObject;

		function addObjectHandler(matcher:Matcher, handler:Function):void;

		function getManagedObject(object:Object):IManagedObject;
	}
}
