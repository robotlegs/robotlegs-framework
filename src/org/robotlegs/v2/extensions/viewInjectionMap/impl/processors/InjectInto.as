//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.viewInjectionMap.impl.processors
{
	import org.swiftsuspenders.Injector;
	
	public class InjectInto
	{
		[Inject]
		public var injector:Injector;

		public function InjectInto()
		{
		}
		
		public function process(item:Object):void
		{
			injector.injectInto(item);
		}

	}
}