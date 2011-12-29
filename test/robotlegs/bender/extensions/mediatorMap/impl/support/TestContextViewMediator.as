//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.impl.support
{
	import flash.events.Event;

	import org.robotlegs.mvcs.Mediator;

	public class TestContextViewMediator extends Mediator
	{
		public static const MEDIATOR_IS_REGISTERED:String = "MediatorIsRegistered";

		[Inject]
		public var view:TestContextView;

		[Inject(name='registered')]
		public var registeredMediators:Array;

		[Inject(name='removed')]
		public var removedMediators:Array;

		public function TestContextViewMediator()
		{
			super();
		}

		/*override public function onRegister() : void
				{
					eventDispatcher.dispatchEvent(new Event(MEDIATOR_IS_REGISTERED));
				}*/

		override public function onRegister():void
		{
			registeredMediators.push(this);
		}

		override public function onRemove():void
		{
			removedMediators.push(this);
		}

	}
}