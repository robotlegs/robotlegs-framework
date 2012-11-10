//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.api
{
	import robotlegs.bender.extensions.matching.ITypeFilter;

	public interface IMediatorMapping
	{
		function get matcher():ITypeFilter;

		function get mediatorClass():Class;

		function get guards():Array;

		function get hooks():Array;

		function validate():void;
	}
}
