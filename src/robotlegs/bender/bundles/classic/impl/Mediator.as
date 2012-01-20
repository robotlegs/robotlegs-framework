//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.bundles.classic.impl
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import robotlegs.bender.extensions.localEventMap.api.IEventMap;
	import robotlegs.bender.extensions.mediatorMap.api.IMediator;

	public class Mediator implements IMediator
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Inject]
		public var eventMap:IEventMap;

		[Inject]
		public var eventDispatcher:IEventDispatcher;

		private var _viewComponent:Object;

		public function set viewComponent(view:Object):void
		{
			_viewComponent = view;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function initialize():void
		{
		}

		public function destroy():void
		{
			eventMap.unmapListeners();
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		protected function addViewListener(eventString:String, listener:Function, eventClass:Class):void
		{
			eventMap.mapListener(IEventDispatcher(_viewComponent), eventString, listener, eventClass);
		}

		protected function addContextListener(eventString:String, listener:Function, eventClass:Class):void
		{
			eventMap.mapListener(eventDispatcher, eventString, listener, eventClass);
		}

		protected function removeViewListener(eventString:String, listener:Function, eventClass:Class):void
		{
			eventMap.unmapListener(IEventDispatcher(_viewComponent), eventString, listener, eventClass);
		}

		protected function removeContextListener(eventString:String, listener:Function, eventClass:Class):void
		{
			eventMap.unmapListener(eventDispatcher, eventString, listener, eventClass);
		}

		protected function dispatch(event:Event):void
		{
			if (eventDispatcher.hasEventListener(event.type))
				eventDispatcher.dispatchEvent(event);
		}
	}
}
