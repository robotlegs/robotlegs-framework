//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.swiftsuspenders.v2.core
{
	import org.swiftsuspenders.v2.dsl.IFactory;
	import org.swiftsuspenders.v2.dsl.IFactoryMapping;
	import org.swiftsuspenders.v2.dsl.IFactoryRequest;

	public class FactoryMapping implements IFactoryMapping
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _factory:IFactory;

		public function get factory():IFactory
		{
			return _factory;
		}

		private var _request:IFactoryRequest;

		public function get request():IFactoryRequest
		{
			return _request;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function FactoryMapping(request:IFactoryRequest, factory:IFactory)
		{
			_request = request;
			_factory = factory;
		}
	}
}
