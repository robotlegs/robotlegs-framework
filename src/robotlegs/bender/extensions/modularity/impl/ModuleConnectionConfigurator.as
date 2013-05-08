//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.modularity.impl
{
	import flash.events.IEventDispatcher;
	import robotlegs.bender.extensions.eventDispatcher.impl.EventRelay;
	import robotlegs.bender.extensions.modularity.dsl.IModuleConnectionAction;

	public class ModuleConnectionConfigurator implements IModuleConnectionAction
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _channelToLocalRelayer:EventRelay;

		private var _localToChannelRelayer:EventRelay;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ModuleConnectionConfigurator(
			localDispatcher:IEventDispatcher,
			channelDispatcher:IEventDispatcher)
		{
			_localToChannelRelayer = new EventRelay(localDispatcher, channelDispatcher, []).start();
			_channelToLocalRelayer = new EventRelay(channelDispatcher, localDispatcher, []).start();
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function relayEvent(eventType:String):IModuleConnectionAction
		{
			_localToChannelRelayer.addType(eventType);
			return this;
		}

		public function receiveEvent(eventType:String):IModuleConnectionAction
		{
			_channelToLocalRelayer.addType(eventType);
			return this;
		}

		public function suspend():void
		{
			_channelToLocalRelayer.stop();
			_localToChannelRelayer.stop();
		}

		public function resume():void
		{
			_channelToLocalRelayer.start();
			_localToChannelRelayer.start();
		}

		public function destroy():void
		{
			_localToChannelRelayer.stop();
			_localToChannelRelayer = null;
			_channelToLocalRelayer.stop();
			_channelToLocalRelayer = null;
		}
	}
}
