//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.commandMap
{
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextExtension;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMap;
	import org.robotlegs.v2.extensions.commandMap.impl.CommandMap;

	public class CommandMapExtension implements IContextExtension
	{
		public function initialize(context:IContext):void
		{
			context.injector.getInstance(ICommandMap);
		}

		public function install(context:IContext):void
		{
			context.injector.map(ICommandMap).toSingleton(CommandMap);
		}

		public function uninstall(context:IContext):void
		{
			context.injector.unmap(ICommandMap);
		}
	}
}
