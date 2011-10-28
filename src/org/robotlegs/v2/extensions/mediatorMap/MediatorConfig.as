//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap
{
	import org.robotlegs.v2.extensions.hooks.GuardsAndHooksConfig;

	public class MediatorConfig extends GuardsAndHooksConfig implements IMediatorConfig
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		protected var _mapping:IMediatorMapping;

		public function get mapping():IMediatorMapping
		{
			return _mapping;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function MediatorConfig(mapping:IMediatorMapping)
		{
			_mapping = mapping;
		}
	}

}
