//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.dsl
{

	/**
	 * Unmaps a Mediator
	 */
	public interface IMediatorUnmapper
	{
		/**
		 * Unmaps a mediator from this matcher
		 * @param mediatorClass Mediator to unmap
		 */
		function fromMediator(mediatorClass:Class):void;

		/**
		 * Unmaps all mediator mappings for this matcher
		 */
		function fromAll():void;
	}
}
