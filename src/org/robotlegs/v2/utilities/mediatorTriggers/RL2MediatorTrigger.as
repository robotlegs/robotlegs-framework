//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.utilities.mediatorTriggers
{
	import flash.display.DisplayObject;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediator;
	
	public class RL2MediatorTrigger
	{
		
		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/
		
		protected var _strict:Boolean;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function RL2MediatorTrigger(strict:Boolean)
		{
			_strict = strict;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function startup(mediator:*, view:DisplayObject):void
		{
			if(_strict || (mediator is IMediator))
			{
				mediator.setViewComponent(view);
				mediator.preRegister();
			}
			
		}

		public function shutdown(mediator:*, view:DisplayObject, callback:Function):void
		{
			if(_strict || (mediator is IMediator))
			{
				mediator.preRemove();
			}
			
			callback(mediator, view);
		}

		/*============================================================================*/
		/* Protected Functions                                                        */
		/*============================================================================*/
		
	}
}