//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl.support
{

	public class MediatorWatcher
	{

		protected const _notifications:Vector.<String> = new Vector.<String>();

		public function get notifications():Vector.<String>
		{
			return _notifications;
		}

		public function notify(message:String):void
		{
			_notifications.push(message);
		}
	}
}
