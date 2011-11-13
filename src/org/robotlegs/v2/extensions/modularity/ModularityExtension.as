//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.modularity
{
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextExtension;
	import org.robotlegs.v2.core.api.IContextPreProcessor;
	import org.robotlegs.v2.extensions.modularity.impl.ParentContextFinder;

	public class ModularityExtension implements IContextExtension, IContextPreProcessor
	{
		private const parentContextFinder:ParentContextFinder = new ParentContextFinder();

		public function preProcess(context:IContext, callback:Function):void
		{
			parentContextFinder.preProcess(context, callback);
		}

		public function install(context:IContext):void
		{
		}

		public function initialize():void
		{
		}

		public function uninstall():void
		{
		}
	}
}
