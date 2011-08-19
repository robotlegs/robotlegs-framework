//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.swiftsuspenders.v2.core
{
	import org.swiftsuspenders.v2.dsl.IFactoryResponse;

	public class FactoryResponse implements IFactoryResponse
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _instance:*;

		public function get instance():*
		{
			return _instance;
		}

		// not needed if the injector keeps a list of provided instances
		private var _isNew:Boolean;

		public function get isNew():Boolean
		{
			return _isNew;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function FactoryResponse(instance:*, isNew:Boolean)
		{
			_instance = instance;
			_isNew = isNew;
		}
	}
}
