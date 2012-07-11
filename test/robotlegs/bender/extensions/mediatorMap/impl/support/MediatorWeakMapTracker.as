//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl.support
{
	import flash.utils.Dictionary;

	public class MediatorWeakMapTracker
	{

		protected const _mediators:Dictionary = new Dictionary(true);

		public function get trackedMediators():Dictionary
		{
			return _mediators;
		}

		public function trackMediator(mediator:*):void
		{
			_mediators[mediator] = true;
		}
	}
}