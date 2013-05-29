//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.dsl
{

	/**
	 * Maps a matcher to a concrete Mediator class
	 */
	public interface IMediatorMapper
	{
		/**
		 * Maps a matcher to a concrete Mediator class
		 * @param mediatorClass The concrete mediator class
		 * @return Mapping configurator
		 */
		function toMediator(mediatorClass:Class):IMediatorConfigurator;
	}
}
