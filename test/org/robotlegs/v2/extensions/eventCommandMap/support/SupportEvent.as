//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.eventCommandMap.support
{
	import flash.events.Event;

	public class SupportEvent extends Event
	{
		public static const TYPE1:String = 'type1';

		public static const TYPE2:String = 'type2';

		public static const TYPE3:String = 'type3';

		public static const TYPE4:String = 'type4';

		public function SupportEvent(type:String)
		{
			super(type);
		}

		override public function clone():Event
		{
			return new SupportEvent(type);
		}
	}
}
