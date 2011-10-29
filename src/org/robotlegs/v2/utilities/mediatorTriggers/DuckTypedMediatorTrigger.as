//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.utilities.mediatorTriggers
{
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorTrigger;
	import flash.display.DisplayObject;
	import flash.utils.describeType;
	
	public class DuckTypedMediatorTrigger implements IMediatorTrigger
	{
		
		/*============================================================================*/
		/* Protected Properties                                                       */
		/*============================================================================*/
		
		protected var _strict:Boolean;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function DuckTypedMediatorTrigger(strict:Boolean)
		{
			_strict = strict;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function startup(mediator:*, view:DisplayObject):void
		{
			if(_strict)
			{
				mediator.setViewComponent(view);
				mediator.preRegister();
				return;
			}

			if(describeType(mediator).method.(@name == "setViewComponent").length() == 1)
			{
				mediator.setViewComponent(view);
			}
			if(describeType(mediator).method.(@name == "preRegister").length() == 1)
			{
				mediator.preRegister();
			}
		}

		public function shutdown(mediator:*, view:DisplayObject, callback:Function):void
		{
			if(_strict)
			{
				mediator.preRemove();
			}
			else if(describeType(mediator).method.(@name == "preRemove").length() == 1)
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