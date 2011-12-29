//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.api
{
	import flash.events.Event;

	public class ViewHandlerEvent extends Event
	{

		public static const HANDLER_CONFIGURATION_CHANGE:String = 'handlerConfigurationChange';

		public function ViewHandlerEvent(type:String)
		{
			super(type);
		}

		override public function clone():Event
		{
			return new ViewHandlerEvent(type);
		}
	}
}
