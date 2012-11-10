//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.dsl
{

	public interface IViewProcessorMappingConfig
	{
		function withGuards(... guards):IViewProcessorMappingConfig;

		function withHooks(... hooks):IViewProcessorMappingConfig;
	}
}
