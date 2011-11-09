//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.commandMap.api
{
	import org.robotlegs.v2.extensions.guards.api.IGuardGroup;
	import org.robotlegs.v2.extensions.hooks.api.IHookGroup;

	public interface ICommandMapping
	{
		function get commandClass():Class;

		function get guards():IGuardGroup;

		function get hooks():IHookGroup;

		function withGuards(... guardClasses):ICommandMapping;

		function withHooks(... hookClasses):ICommandMapping;
	}
}
