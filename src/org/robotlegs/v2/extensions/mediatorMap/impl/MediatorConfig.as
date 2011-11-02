//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.impl
{
	import org.robotlegs.v2.extensions.guardsAndHooks.impl.GuardsAndHooksConfig;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorConfig;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorMapping;

	public class MediatorConfig extends GuardsAndHooksConfig implements IMediatorConfig
	{

		protected var _mapping:IMediatorMapping;

		public function get mapping():IMediatorMapping
		{
			return _mapping;
		}

		public function MediatorConfig(mapping:IMediatorMapping)
		{
			_mapping = mapping;
		}
	}

}
