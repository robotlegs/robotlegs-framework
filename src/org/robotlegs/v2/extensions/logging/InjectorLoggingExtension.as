//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.logging
{
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextExtension;
	import org.robotlegs.v2.core.api.ILogger;
	import org.swiftsuspenders.InjectionEvent;
	import org.swiftsuspenders.Injector;
	import org.swiftsuspenders.MappingEvent;

	public class InjectorLoggingExtension implements IContextExtension
	{

		private var context:IContext;

		private var logger:ILogger;

		public function install(context:IContext):void
		{
			this.context = context;
			// todo: fixme
			logger = context.logger;
			const injector:Injector = context.injector;
			injector.addEventListener(InjectionEvent.POST_CONSTRUCT, onInjectionEvent);
			injector.addEventListener(InjectionEvent.POST_INSTANTIATE, onInjectionEvent);
			injector.addEventListener(InjectionEvent.PRE_CONSTRUCT, onInjectionEvent);
			injector.addEventListener(MappingEvent.POST_MAPPING_CHANGE, onMappingEvent)
			injector.addEventListener(MappingEvent.POST_MAPPING_CREATE, onMappingEvent);
			injector.addEventListener(MappingEvent.PRE_MAPPING_CHANGE, onMappingEvent);
			injector.addEventListener(MappingEvent.PRE_MAPPING_CREATE, onMappingEvent);
		}

		public function initialize():void
		{
		}

		public function uninstall():void
		{
			const injector:Injector = context.injector;
			injector.removeEventListener(InjectionEvent.POST_CONSTRUCT, onInjectionEvent);
			injector.removeEventListener(InjectionEvent.POST_INSTANTIATE, onInjectionEvent);
			injector.removeEventListener(InjectionEvent.PRE_CONSTRUCT, onInjectionEvent);
			injector.removeEventListener(MappingEvent.POST_MAPPING_CHANGE, onMappingEvent)
			injector.removeEventListener(MappingEvent.POST_MAPPING_CREATE, onMappingEvent);
			injector.removeEventListener(MappingEvent.PRE_MAPPING_CHANGE, onMappingEvent);
			injector.removeEventListener(MappingEvent.PRE_MAPPING_CREATE, onMappingEvent);
		}

		private function onInjectionEvent(event:InjectionEvent):void
		{
			logger.info('{0}, instance: {1}, type: {2}', [event.type, event.instance, event.instanceType]);
		}

		private function onMappingEvent(event:MappingEvent):void
		{
			logger.info('{0}, mappedType: {1}, mappedName: {2}', [event.type, event.mappedType, event.mappedName]);
		}
	}
}
