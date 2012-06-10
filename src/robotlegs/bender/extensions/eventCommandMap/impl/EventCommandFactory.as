// ------------------------------------------------------------------------------
// Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
// NOTICE: You are permitted to use, modify, and distribute this file
// in accordance with the terms of the license agreement accompanying it.
// ------------------------------------------------------------------------------
package robotlegs.bender.extensions.eventCommandMap.impl {
	import robotlegs.bender.extensions.commandMap.api.ICommandMapping;
	import robotlegs.bender.framework.impl.applyHooks;

	import org.swiftsuspenders.Injector;

	public class EventCommandFactory {
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/
		private var _mapping : ICommandMapping;
		private var _injector : Injector;

		/*============================================================================*/
		/* Constructor                                                    */
		/*============================================================================*/
		public function EventCommandFactory(mapping : ICommandMapping, injector : Injector) {
			_injector = injector;
			_mapping = mapping;
		}

		/*============================================================================*/
		/* Public Functions                                                         */
		/*============================================================================*/
		public function create() : * {
			var command : *;

			mapCommandForInjection();
			command = _injector.getInstance(_mapping.commandClass);
			applyHooks(_mapping.hooks, _injector);
			unmapCommandAfterInjection();

			cleanUp();

			return command;
		}

		/*============================================================================*/
		/* Private Functions                                                         */
		/*============================================================================*/
		private function cleanUp() : void {
			_mapping = null;
			_injector = null;
		}

		private function mapCommandForInjection() : void {
			_injector.map(_mapping.commandClass).asSingleton();
		}

		private function unmapCommandAfterInjection() : void {
			_injector.unmap(_mapping.commandClass);
		}
	}
}
