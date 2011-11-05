//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.commandMap.support
{

	public class CallbackCommand
	{

		[Inject(name="callback")]
		public var callback:Function;

		public function execute():void
		{
			callback();
		}
	}
}
