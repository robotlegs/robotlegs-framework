//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.swiftsuspenders.v2.factories
{
	import org.swiftsuspenders.v2.dsl.IFactory;
	import org.swiftsuspenders.v2.dsl.IFactoryRequest;
	import org.swiftsuspenders.v2.dsl.IFactoryResponse;

	public class SingletonFactory implements IFactory
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var implementation:Class;

		private var instance:*;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function SingletonFactory(implementation:Class = null)
		{
			this.implementation = implementation;
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function process(request:IFactoryRequest):IFactoryResponse
		{
			const ResponseClass:Class = implementation || request.type;
			instance ||= new ResponseClass();
			return instance;
		}
	}
}
