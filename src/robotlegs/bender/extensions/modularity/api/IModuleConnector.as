//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.modularity.api
{
	import robotlegs.bender.extensions.modularity.dsl.IModuleConnectionAction;

	/**
	 * Creates event relays between modules
	 */
	public interface IModuleConnector
	{
		/**
		 * Connects to a specified channel
		 * @param channelId The channel Id
		 * @return Configurator
		 */
		function onChannel(channelId:String):IModuleConnectionAction;

		/**
		 * Connects to the default channel
		 * @return Configurator
		 */
		function onDefaultChannel():IModuleConnectionAction;
	}
}
