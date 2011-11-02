//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.impl.support
{
	import org.robotlegs.v2.extensions.mediatorMap.impl.Mediator;

	public class TrackingMediator extends Mediator
	{
		public static const INITIALIZE:String = "TrackingMediator initialize";

		public static const DESTROY:String = "TrackingMediator destroy";

		protected var _mediatorWatcher:MediatorWatcher;

		public function TrackingMediator(mediatorWatcher:MediatorWatcher)
		{
			_mediatorWatcher = mediatorWatcher;
		}

		override public function initialize():void
		{
			_mediatorWatcher.notify(INITIALIZE);
		}

		override public function destroy():void
		{
			_mediatorWatcher.notify(DESTROY);
		}
	}

}
