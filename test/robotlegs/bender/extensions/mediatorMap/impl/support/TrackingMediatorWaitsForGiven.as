//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl.support
{
	import robotlegs.bender.extensions.mediatorMap.impl.Mediator;

	public class TrackingMediatorWaitsForGiven extends Mediator
	{

		public static const ON_REGISTER:String = "TrackingMediatorWaitsForGiven onRegister";

		public static const ON_REMOVE:String = "TrackingMediatorWaitsForGiven onRemove";

		protected var _mediatorWatcher:MediatorWatcher;

		public function TrackingMediatorWaitsForGiven(mediatorWatcher:MediatorWatcher, eventTypeToWaitFor:String, eventClassToWaitFor:Class)
		{
			_mediatorWatcher = mediatorWatcher;
			waitForEvent(eventTypeToWaitFor, eventClassToWaitFor);
		}

		override protected function onRegister():void
		{
			_mediatorWatcher.notify(ON_REGISTER);
		}

		override protected function onRemove():void
		{
			_mediatorWatcher.notify(ON_REMOVE);
		}
	}

}
