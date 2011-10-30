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
		protected var _mediatorWatcher:MediatorWatcher;
	
		public static const ON_REGISTER:String = "TrackingMediator onRegister";
		public static const ON_REMOVE:String = "TrackingMediator onRemove";
	
		public function TrackingMediator(mediatorWatcher:MediatorWatcher)
		{
			_mediatorWatcher = mediatorWatcher;
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