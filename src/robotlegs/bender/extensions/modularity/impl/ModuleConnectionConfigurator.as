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

		private var _channelToLocalRelay:EventRelay;

		private var _localToChannelRelay:EventRelay;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function ModuleConnectionConfigurator(
			localDispatcher:IEventDispatcher,
			channelDispatcher:IEventDispatcher)
		{
			_localToChannelRelay = new EventRelay(localDispatcher, channelDispatcher).start();
			_channelToLocalRelay = new EventRelay(channelDispatcher, localDispatcher).start();
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function relayEvent(eventType:String):IModuleConnectionAction
		{
			_localToChannelRelay.addType(eventType);
			return this;
		}

		public function receiveEvent(eventType:String):IModuleConnectionAction
		{
			_channelToLocalRelay.addType(eventType);
			return this;
		}

		public function suspend():void
		{
			_channelToLocalRelay.stop();
			_localToChannelRelay.stop();
		}

		public function resume():void
		{
			_channelToLocalRelay.start();
			_localToChannelRelay.start();
		}

		public function destroy():void
		{
			_localToChannelRelay.stop();
			_localToChannelRelay = null;
			_channelToLocalRelay.stop();
			_channelToLocalRelay = null;
		}
	}
}
