//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.hooks
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import org.robotlegs.v2.core.api.ITypeMatcher;
	import org.robotlegs.v2.view.api.IViewClassInfo;
	import org.robotlegs.v2.view.api.IViewHandler;
	import org.robotlegs.v2.view.api.ViewHandlerEvent;

	[Event(name="configurationChange", type="org.robotlegs.v2.view.api.ViewHandlerEvent")]
	public class ViewHookMap extends EventDispatcher implements IViewHandler
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		[Inject]
		public var hookMap:HookMap;

		public function get interests():uint
		{
			return 1;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ViewHookMap()
		{
		}


		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function handleViewAdded(view:DisplayObject, info:IViewClassInfo):uint
		{
			if (hookMap.process(view))
				return 1;

			return 0;
		}

		public function handleViewRemoved(view:DisplayObject):void
		{
			// do nothing
		}

		public function invalidate():void
		{
			dispatchEvent(new ViewHandlerEvent(ViewHandlerEvent.CONFIGURATION_CHANGE));
		}

		public function map(type:Class):GuardsAndHooksConfig
		{
			return hookMap.map(type);
		}

		public function mapMatcher(matcher:ITypeMatcher):GuardsAndHooksConfig
		{
			return hookMap.mapMatcher(matcher);
		}
	}
}
