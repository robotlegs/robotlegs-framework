//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.commandMap.support
{
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMapping;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandTrigger;

	public class CallbackCommandTrigger implements ICommandTrigger
	{
		private var _registerCallback:Function;

		private var _unregisterCallback:Function;

		public function CallbackCommandTrigger(registerCallback:Function = null, unregisterCallback:Function = null)
		{
			_registerCallback = registerCallback;
			_unregisterCallback = unregisterCallback;
		}

		public function register(mapping:ICommandMapping):void
		{
			_registerCallback && _registerCallback(mapping);
		}

		public function unregister():void
		{
			_unregisterCallback && _unregisterCallback();
		}
	}
}
