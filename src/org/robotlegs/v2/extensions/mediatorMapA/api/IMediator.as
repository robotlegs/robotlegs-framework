//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMapA.api
{

	public interface IMediator
	{
		/**
		 * Should be invoked by the <code>IMediatorMap</code> during <code>IMediator</code> registration
		 */
		function initialize():void;

		/**
		 * Invoked when the <code>IMediator</code> has been removed by the <code>IMediatorMap</code>
		 */
		function destroy():void;

		/**
		 * The <code>IMediator</code>'s view component
		 *
		 * @return The view component
		 */
		function getViewComponent():Object;

		/**
		 * The <code>IMediator</code>'s view component
		 *
		 * @param The view component
		 */
		function setViewComponent(viewComponent:Object):void;
		
		function get destroyed():Boolean;
		
		function set destroyed(value:Boolean):void;
	}
}

