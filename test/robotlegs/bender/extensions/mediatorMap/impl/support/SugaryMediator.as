//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl.support
{
	import flash.events.Event;
	import robotlegs.bender.bundles.mvcs.Mediator;

	public class SugaryMediator extends Mediator
	{
		override public function initialize():void
		{
		}

		override public function destroy():void
		{
		}

		public function try_addViewListener(eventString:String, callback:Function, eventClass:Class):void
		{
			addViewListener(eventString, callback, eventClass);
		}

		public function try_addContextListener(eventString:String, callback:Function, eventClass:Class):void
		{
			addContextListener(eventString, callback, eventClass);
		}

		public function try_removeViewListener(eventString:String, callback:Function, eventClass:Class):void
		{
			removeViewListener(eventString, callback, eventClass);
		}

		public function try_removeContextListener(eventString:String, callback:Function, eventClass:Class):void
		{
			removeContextListener(eventString, callback, eventClass);
		}

		public function try_dispatch(e:Event):void
		{
			dispatch(e);
		}

	}

}