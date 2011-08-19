//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.swiftsuspenders.v2.core
{
	import org.swiftsuspenders.v2.dsl.IFactoryMap;
	import org.swiftsuspenders.v2.dsl.IFactoryMapping;

	public class FactoryMap implements IFactoryMap
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		private var _mappings:Vector.<IFactoryMapping> = new Vector.<IFactoryMapping>;

		public function get mappings():Vector.<IFactoryMapping>
		{
			return _mappings;
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function addMapping(mapping:IFactoryMapping):void
		{
			mappings.push(mapping);
		}
	}
}
