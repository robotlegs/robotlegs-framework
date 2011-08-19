//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.context.restricted
{
	import org.robotlegs.v2.context.api.IContext;
	import org.swiftsuspenders.v2.dsl.IInjector;

	public class Context implements IContext
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		protected var _injector:IInjector;

		public function get injector():IInjector
		{
			return _injector;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function Context(injector:IInjector)
		{
			_injector = injector;
		}
	}
}
