//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.eventCommandMap.impl
{
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.extensions.commandMap.api.ICommandMapping;
	import robotlegs.bender.framework.impl.applyHooks;

	public class EventCommandFactory
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _injector:Injector;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function EventCommandFactory(injector:Injector)
		{
			_injector = injector;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function create(mapping:ICommandMapping):Object
		{
			const commandClass:Class = mapping.commandClass;

			_injector.map(commandClass).asSingleton();
			const command:Object = _injector.getInstance(commandClass);
			applyHooks(mapping.hooks, _injector);
			_injector.unmap(commandClass);

			return command;
		}
	}
}
