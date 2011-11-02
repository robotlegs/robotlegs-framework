//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.viewHookMap
{
	import flash.display.DisplayObject;
	import flash.events.EventDispatcher;
	import org.robotlegs.v2.core.api.ITypeMatcher;
	import org.robotlegs.v2.extensions.viewManager.api.IViewClassInfo;
	import org.robotlegs.v2.extensions.viewManager.api.IViewHandler;
	import org.robotlegs.v2.extensions.viewManager.api.ViewHandlerEvent;
	import org.robotlegs.v2.extensions.guardsAndHooks.impl.GuardsAndHooksConfig;

	[Event(name="configurationChange", type="org.robotlegs.v2.extensions.viewManager.api.ViewHandlerEvent")]
	public class ViewHookMap extends EventDispatcher implements IViewHandler
	{

		[Inject]
		public var hookMap:HookMap;

		public function get interests():uint
		{
			return 1;
		}

		public function ViewHookMap()
		{
		}

		public function processView(view:DisplayObject, info:IViewClassInfo):uint
		{
			if (hookMap.process(view))
				return 1;

			return 0;
		}

		public function releaseView(view:DisplayObject):void
		{
			// do nothing
		}

		public function invalidate():void
		{
			dispatchEvent(new ViewHandlerEvent(ViewHandlerEvent.HANDLER_CONFIGURATION_CHANGE));
		}

		public function map(type:Class):GuardsAndHooksConfig
		{
			return hookMap.map(type);
		}

		public function mapMatcher(matcher:ITypeMatcher):GuardsAndHooksConfig
		{
			return hookMap.mapMatcher(matcher);
		}
		
		public function destroy():void
		{
		}
	}
}