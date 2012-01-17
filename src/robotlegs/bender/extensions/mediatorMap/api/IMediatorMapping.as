//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.api
{
	import org.hamcrest.Matcher;
	import robotlegs.bender.framework.guard.api.IGuardGroup;
	import robotlegs.bender.framework.hook.api.IHookGroup;

	public interface IMediatorMapping
	{
		function get matcher():Matcher;

		function get mediatorClass():Class;

		function get viewType():Class;

		function get factory():IMediatorFactory;

		function get guards():IGuardGroup;

		function get hooks():IHookGroup;
	}
}
