//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.logging
{
	import robotlegs.bender.core.api.IContext;
	import robotlegs.bender.core.api.IContextExtension;
	import robotlegs.bender.core.api.IContextLogger;
	import org.swiftsuspenders.InjectionEvent;
	import org.swiftsuspenders.Injector;
	import org.swiftsuspenders.MappingEvent;

	public class InjectorLoggingExtension implements IContextExtension
	{

		private var context:IContext;

		private var injector:Injector;

		private var logger:IContextLogger;

		public function install(context:IContext):void
		{
			this.context = context;
			logger = context.logger;
			injector = context.injector;
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
			injector.removeEventListener(InjectionEvent.POST_CONSTRUCT, onInjectionEvent);
			injector.removeEventListener(InjectionEvent.POST_INSTANTIATE, onInjectionEvent);
			injector.removeEventListener(InjectionEvent.PRE_CONSTRUCT, onInjectionEvent);
			injector.removeEventListener(MappingEvent.POST_MAPPING_CHANGE, onMappingEvent)
			injector.removeEventListener(MappingEvent.POST_MAPPING_CREATE, onMappingEvent);
			injector.removeEventListener(MappingEvent.PRE_MAPPING_CHANGE, onMappingEvent);
			injector.removeEventListener(MappingEvent.PRE_MAPPING_CREATE, onMappingEvent);
		}

		public function toString():String
		{
			return 'InjectorLoggingExtension';
		}

		private function onInjectionEvent(event:InjectionEvent):void
		{
			logger.info(this, '{0}, instance: {1}, type: {2}', [event.type, event.instance, event.instanceType]);
		}

		private function onMappingEvent(event:MappingEvent):void
		{
			logger.info(this, '{0}, mappedType: {1}, mappedName: {2}', [event.type, event.mappedType, event.mappedName]);
		}
	}
}
