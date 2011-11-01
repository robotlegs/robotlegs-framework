//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.utilities.triggers
{
	import flash.display.DisplayObject;
	import flash.utils.describeType;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorTrigger;
	import org.robotlegs.v2.core.utilities.objectHasMethod;
	import flash.errors.IllegalOperationError;

	public class DuckTypedMediatorTrigger implements IMediatorTrigger
	{

		protected var _strict:Boolean;

		public function DuckTypedMediatorTrigger(strict:Boolean)
		{
			_strict = strict;
		}

		public function startup(mediator:*, view:DisplayObject):void
		{
			if (_strict)
			{
				mediator.setViewComponent(view);
			}
			else if (objectHasMethod(mediator, 'setViewComponent'))
			{
				mediator.setViewComponent(view);
			}
			
			if (objectHasMethod(mediator, 'preRegister'))
			{
				mediator.preRegister();
			}
			else if (objectHasMethod(mediator, 'initialize'))
			{
				mediator.initialize();
			}
			else if(_strict)
			{
				throwError("startup", mediator,  ['preRegister', 'initialize']);
			}
		}

		public function shutdown(mediator:*, view:DisplayObject, callback:Function):void
		{
			if (objectHasMethod(mediator, 'preRemove'))
			{
				mediator.preRemove();
			}
			else if(objectHasMethod(mediator, 'destroy'))
			{
				mediator.destroy();
			}
			else if(_strict)
			{
				throwError("shutdown", mediator, ['preRemove', 'destroy']);
			}
			callback(mediator, view);
		}
		
		protected function throwError(operationName:String, mediator:Object, methods:Array):void
		{
			throw new IllegalOperationError("Attempted " + operationName + " on " + mediator + " but no expected methods ( " +  methods +  " ) were found.");
		}
	}
}