//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMapA.utilities.triggers
{
	import flash.display.DisplayObject;
	import org.robotlegs.v2.extensions.mediatorMapA.api.IMediatorTrigger;
	import org.robotlegs.v2.extensions.mediatorMapA.api.IMediator;
	import org.robotlegs.core.IMediator;
	import org.robotlegs.v2.extensions.mediatorMapA.utilities.triggers.RL2MediatorTrigger;
	
	public class RL1AndRL2MediatorTrigger extends RL2MediatorTrigger 
	{

		protected const RL1MediatorType:Class = org.robotlegs.core.IMediator;
		protected const RL2MediatorType:Class = org.robotlegs.v2.extensions.mediatorMapA.api.IMediator;
	
		protected const NOT_A_MEDIATOR:String = "In strict mode RL1AndRL2MediatorTrigger expects" +
												" mediators to implement " + RL1MediatorType +
											  	" or " + RL2MediatorType;
																						
		public function RL1AndRL2MediatorTrigger(strict:Boolean)
		{
			super(strict);
		}
		
		override public function startup(mediator:*, view:DisplayObject):void
		{
			if(mediator is RL1MediatorType)
			{
				mediator.setViewComponent(view);
				mediator.preRegister();
			}
			else if(mediator is RL2MediatorType)
			{
				super.startup(mediator, view);
			}
			else if(_strict)
			{
				throwNotAMediatorError();
			}
		}

		override public function shutdown(mediator:*, view:DisplayObject, callback:Function):void
		{
			if(mediator is RL1MediatorType)
			{
				mediator.preRemove();
				callback(mediator, view);
			}
			else if(mediator is RL2MediatorType)
			{
				super.shutdown(mediator, view, callback);
			}
			else if(_strict)
			{
				throwNotAMediatorError();
			}
		}
		
		protected function throwNotAMediatorError():void
		{
			throw new ArgumentError(NOT_A_MEDIATOR)
		}

	}
}