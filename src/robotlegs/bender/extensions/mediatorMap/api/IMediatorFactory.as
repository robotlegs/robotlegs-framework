//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.api
{

	public interface IMediatorFactory
	{
		/**
		 * Mediator factory function
		 *
		 * @param view The view instance to create a mediator for.
		 * @param mapping The mediator mapping to use.
		 * @return The mediator
		 */
		function createMediator(view:Object, mapping:IMediatorMapping):Object;
	}
}
