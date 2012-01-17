//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.api
{
	import org.hamcrest.Matcher;
	import robotlegs.bender.extensions.viewManager.api.IViewHandler;

	public interface IMediatorMap extends IViewHandler
	{
		function map(matcher:Matcher):IMediatorMapper;
		function unmap(matcher:Matcher):IMediatorUnmapper;
		function getMapping(matcher:Matcher):IMediatorMappingFinder;
	}
}
