//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.logging.impl
{
	import org.swiftsuspenders.InjectionEvent;
	import org.swiftsuspenders.Injector;
	import org.swiftsuspenders.mapping.MappingEvent;
	import robotlegs.bender.framework.api.ILogger;

	public class InjectorListener
	{

		/*============================================================================*/
		/* Private Static Properties                                                  */
		/*============================================================================*/

		private static const INJECTION_TYPES:Array = [
			InjectionEvent.POST_CONSTRUCT,
			InjectionEvent.POST_INSTANTIATE,
			InjectionEvent.PRE_CONSTRUCT];

		private static const MAPPING_TYPES:Array = [
			MappingEvent.MAPPING_OVERRIDE,
			MappingEvent.POST_MAPPING_CHANGE,
			MappingEvent.POST_MAPPING_CREATE,
			MappingEvent.POST_MAPPING_REMOVE,
			MappingEvent.PRE_MAPPING_CHANGE,
			MappingEvent.PRE_MAPPING_CREATE];

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _injector:Injector;

		private var _logger:ILogger;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function InjectorListener(injector:Injector, logger:ILogger)
		{
			_injector = injector;
			_logger = logger;
			addListeners();
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function destroy():void
		{
			var type:String;
			for each (type in INJECTION_TYPES)
			{
				_injector.removeEventListener(type, onInjectionEvent);
			}
			for each (type in MAPPING_TYPES)
			{
				_injector.removeEventListener(type, onMappingEvent);
			}
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function addListeners():void
		{
			var type:String;
			for each (type in INJECTION_TYPES)
			{
				_injector.addEventListener(type, onInjectionEvent);
			}
			for each (type in MAPPING_TYPES)
			{
				_injector.addEventListener(type, onMappingEvent);
			}
		}

		private function onInjectionEvent(event:InjectionEvent):void
		{
			_logger.debug("Injection event of type {0}. Instance: {1}. Instance type: {2}",
				[event.type, event.instance, event.instanceType]);
		}

		private function onMappingEvent(event:MappingEvent):void
		{
			_logger.debug("Mapping event of type {0}. Mapped type: {1}. Mapped name: {2}",
				[event.type, event.mappedType, event.mappedName]);
		}
	}
}
