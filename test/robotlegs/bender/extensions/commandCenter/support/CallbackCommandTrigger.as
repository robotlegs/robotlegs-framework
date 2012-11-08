//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter.support
{
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
	import robotlegs.bender.extensions.commandCenter.api.ICommandTrigger;

	public class CallbackCommandTrigger implements ICommandTrigger
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _registerCallback:Function;

		private var _unregisterCallback:Function;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function CallbackCommandTrigger(registerCallback:Function = null, unregisterCallback:Function = null)
		{
			_registerCallback = registerCallback;
			_unregisterCallback = unregisterCallback;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function addMapping(mapping:ICommandMapping):void
		{
			_registerCallback && _registerCallback(mapping);
		}

		public function removeMapping(mapping:ICommandMapping):void
		{
			_unregisterCallback && _unregisterCallback(mapping);
		}
	}
}
