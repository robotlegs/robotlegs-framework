//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewManager.impl.support
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import robotlegs.bender.extensions.viewManager.api.IViewClassInfo;
	import robotlegs.bender.extensions.viewManager.api.IViewHandler;
	import robotlegs.bender.extensions.viewManager.api.ViewHandlerEvent;

	[Event(name="configurationChange", type="robotlegs.bender.extensions.viewManager.api.ViewHandlerEvent")]
	public class ViewHandlerSupport extends EventDispatcher implements IViewHandler
	{

		public static const INTEREST_0:uint = 0x000000; // illegal

		public static const INTEREST_1:uint = 0x000001;

		public static const INTEREST_2:uint = 0x000004;

		public static const INTEREST_3:uint = 0x000010;

		public static const INTEREST_4:uint = 0x000040;

		public static const INTEREST_5:uint = 0x000100;

		public static const INTEREST_6:uint = 0x000400;

		public static const INTEREST_7:uint = 0x001000;

		public static const INTEREST_8:uint = 0x004000;

		protected var _interests:uint;

		public function get interests():uint
		{
			return _interests;
		}

		protected var _addedHandler:Function;

		protected var _blocking:Boolean;

		protected var _interestsToActuallyHandle:uint;

		protected var _removedHandler:Function;

		public function ViewHandlerSupport(
			interests:uint = 1,
			interestsToActuallyHandle:uint = 0,
			blocking:Boolean = false,
			addedHandler:Function = null,
			removedHandler:Function = null)
		{
			_interests = interests;
			_interestsToActuallyHandle = interestsToActuallyHandle;
			_blocking = blocking;
			_addedHandler = addedHandler;
			_removedHandler = removedHandler;
		}

		public function processView(view:DisplayObject, info:IViewClassInfo):uint
		{
			var response:uint = _interestsToActuallyHandle;

			if (_blocking)
				response |= _interestsToActuallyHandle << 1;

			_addedHandler && _addedHandler(view, info, response);

			return response;
		}

		public function releaseView(view:DisplayObject):void
		{
			_removedHandler && _removedHandler(view);
		}

		public function invalidate():void
		{
			dispatchEvent(new ViewHandlerEvent(ViewHandlerEvent.HANDLER_CONFIGURATION_CHANGE));
		}

		public function destroy():void
		{
		}
	}
}
