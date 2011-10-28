//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.commandMap.impl
{
	import flash.utils.Dictionary;

	import org.robotlegs.v2.extensions.commandMap.api.ICommandMap;
	import org.robotlegs.v2.extensions.commandMap.api.ICommandMapping;

	public class CommandMap implements ICommandMap
	{
		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const _mappings : Dictionary = new Dictionary();

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function map(commandType:Class):ICommandMapping
		{
			return _mappings[commandType] ||= new CommandMapping(commandType);
		}

		public function unmap(commandType:Class):void
		{
			delete _mappings[commandType];
		}

		public function hasMapping(commandType:Class):Boolean
		{
			return _mappings[commandType];
		}
	}
}