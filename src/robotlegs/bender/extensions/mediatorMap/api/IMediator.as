//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.api
{

	/**
	 * Optional Mediator interface
	 */
	public interface IMediator
	{
		/**
		 * Initializes the mediator. This is run automatically by the mediatorMap when a mediator is created.
		 * Normally the initialize function is where you would add handlers using the eventMap.
		 */
		function initialize():void;

		/**
		 * Destroys the mediator. This is run automatically by the mediatorMap when a mediator is destroyed.
		 * You should clean up any handlers that were added directly (eventMap handlers will be cleaned up automatically).
		 */
		function destroy():void;
	}
}
