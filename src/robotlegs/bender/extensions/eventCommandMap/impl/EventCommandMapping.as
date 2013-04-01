//------------------------------------------------------------------------------
//  Copyright (c) 2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------
package robotlegs.bender.extensions.eventCommandMap.impl
{
	import robotlegs.bender.extensions.commandCenter.api.ICommandMapping;
	import robotlegs.bender.extensions.commandCenter.impl.CommandMapping;
	import robotlegs.bender.extensions.eventCommandMap.api.IEventCommandMapping;

	public class EventCommandMapping extends CommandMapping implements IEventCommandMapping
	{
		private var _priority:int;

		/**
		 * @inheritDoc
		 */
		public function get priority():int
		{
			return _priority;
		}

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		/**
		 * Creates a Command Mapping
		 * @param commandClass The concrete Command class
		 */
		public function EventCommandMapping(commandClass:Class)
		{
			super(commandClass);
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function setPriority(priority:int):ICommandMapping
		{
			_priority = priority;
			return this;
		}

	}
}
