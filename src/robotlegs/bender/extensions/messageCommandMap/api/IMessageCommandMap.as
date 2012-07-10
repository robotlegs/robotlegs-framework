//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.messageCommandMap.api
{
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMapper;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandMappingFinder;
	import robotlegs.bender.extensions.commandCenter.dsl.ICommandUnmapper;

	public interface IMessageCommandMap
	{
		function map(message:Object):ICommandMapper;

		function unmap(message:Object):ICommandUnmapper;

		function getMapping(message:Object):ICommandMappingFinder;
	}
}
