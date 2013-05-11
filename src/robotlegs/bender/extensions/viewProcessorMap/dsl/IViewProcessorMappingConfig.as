//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.dsl
{

	/**
	 * View Processor Mapping Configuration
	 */
	public interface IViewProcessorMappingConfig
	{
		/**
		 * A list of guards to consult before allowing a view to be processed
		 * @param guards A list of guards
		 * @return Self
		 */
		function withGuards(... guards):IViewProcessorMappingConfig;

		/**
		 * A list of hooks to run before processing a view
		 * @param hooks A list of hooks
		 * @return Self
		 */
		function withHooks(... hooks):IViewProcessorMappingConfig;
	}
}
