//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.bundles.rl1
{
	import org.robotlegs.v2.core.api.IContextBuilder;
	import org.robotlegs.v2.core.api.IContextBuilderBundle;
	import org.robotlegs.v2.processors.ParentContextFinder;

	public class RLv1Bundle implements IContextBuilderBundle
	{

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function install(builder:IContextBuilder):void
		{
			builder
				.withProcessor(new ParentContextFinder())
				.withExtension(new RLv1Extension());
		}
	}
}
