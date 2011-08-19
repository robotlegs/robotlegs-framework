//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.swiftsuspenders.v2.core
{
	import org.swiftsuspenders.v2.dsl.IFactoryRequest;

	public class FactoryRequest implements IFactoryRequest
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _name:String;

		public function get name():String
		{
			return _name;
		}

		private var _type:Class;

		public function get type():Class
		{
			return _type;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function FactoryRequest(type:Class, name:String = '')
		{
			_type = type;
			_name = name;
		}
	}
}
