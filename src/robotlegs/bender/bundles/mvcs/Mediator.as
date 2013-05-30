//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.bundles.mvcs
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import robotlegs.bender.extensions.localEventMap.api.IEventMap;
	import robotlegs.bender.extensions.mediatorMap.api.IMediator;

	/**
	 * Classic Robotlegs mediator implementation
	 *
	 * <p>Override initialize and destroy to hook into the mediator lifecycle.</p>
	 */
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

		/**
		 * @private
		 */
		public function set viewComponent(view:Object):void
		{
			_viewComponent = view;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function initialize():void
		{
		}

		/**
		 * @inheritDoc
		 */
		public function destroy():void
		{
		}

		/**
		 * Runs after the mediator has been destroyed.
		 * Cleans up listeners mapped through the local EventMap.
		 */
		public function postDestroy():void
		{
			eventMap.unmapListeners();
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/

		protected function addViewListener(eventString:String, listener:Function, eventClass:Class = null):void
		{
			eventMap.mapListener(IEventDispatcher(_viewComponent), eventString, listener, eventClass);
		}

		protected function addContextListener(eventString:String, listener:Function, eventClass:Class = null):void
		{
			eventMap.mapListener(eventDispatcher, eventString, listener, eventClass);
		}

		protected function removeViewListener(eventString:String, listener:Function, eventClass:Class = null):void
		{
			eventMap.unmapListener(IEventDispatcher(_viewComponent), eventString, listener, eventClass);
		}

		protected function removeContextListener(eventString:String, listener:Function, eventClass:Class = null):void
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
