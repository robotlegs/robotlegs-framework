//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.api
{
	import org.hamcrest.Matcher;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMapper;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorMappingFinder;
	import robotlegs.bender.extensions.mediatorMap.dsl.IMediatorUnmapper;
	import robotlegs.bender.extensions.viewManager.api.IViewHandler;

	public interface IMediatorMap extends IViewHandler
	{
		function map(matcher:Matcher):IMediatorMapper;

		function mapView(viewType:Class):IMediatorMapper;

		function getMapping(matcher:Matcher):IMediatorMappingFinder;

		function getViewMapping(viewType:Class):IMediatorMappingFinder;

		function unmap(matcher:Matcher):IMediatorUnmapper;

		function unmapView(viewType:Class):IMediatorUnmapper;
	}
}
