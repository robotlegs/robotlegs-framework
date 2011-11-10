//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMapA.utilities.triggers
{
	import flash.display.DisplayObject;
	import flash.utils.describeType;
	import org.robotlegs.v2.extensions.mediatorMapA.api.IMediatorTrigger;
	import org.robotlegs.v2.core.utilities.objectHasMethod;
	import flash.errors.IllegalOperationError;
	import org.robotlegs.v2.core.api.ITypeMatcher;
	import flash.utils.Dictionary;
	import org.robotlegs.v2.extensions.mediatorMapA.utilities.strategies.NoWaitStrategy;
	import org.robotlegs.v2.core.api.ITypeFilter;
	import org.robotlegs.v2.extensions.mediatorMapA.api.IMediatorStartupStrategy;
	import org.robotlegs.v2.extensions.mediatorMapA.api.IStrategicTrigger;

	public class DuckTypedMediatorTrigger extends StrategicTriggerBase
	{
		protected var _strict:Boolean;

		public function DuckTypedMediatorTrigger(strict:Boolean)
		{
			_strict = strict;
		}

		override public function startup(mediator:*, view:DisplayObject):void
		{
			if (_strict)
			{
				throwErrorIfUnimplemented(mediator, ['preRegister', 'initialize'])
			}

			if (_strict)
			{
				mediator.setViewComponent(view);
			}
			else if (objectHasMethod(mediator, 'setViewComponent'))
			{
				mediator.setViewComponent(view);
			}
			
			if(mediator.hasOwnProperty('destroyed'))
			{
				mediator.destroyed = false;
			}
			
			if (objectHasMethod(mediator, 'preRegister'))
			{
				mediator.preRegister();
			}
			else if (objectHasMethod(mediator, 'initialize'))
			{
				startupWithStrategy(mediator, view);
			}
			
		}

		override public function shutdown(mediator:*, view:DisplayObject, callback:Function):void
		{
			if(_strict)
			{
				throwErrorIfUnimplemented(mediator, ['preRemove', 'destroy']);
			}
			
			if (objectHasMethod(mediator, 'preRemove'))
			{
				mediator.preRemove();
			}
			else if(objectHasMethod(mediator, 'destroy'))
			{
				mediator.destroy();
			}
			
			if(mediator.hasOwnProperty('destroyed'))
			{
				mediator.destroyed = true;
			}
			
			callback(mediator, view);
		}
		
		protected function throwErrorIfUnimplemented(mediator:Object, methods:Array):void
		{
			for each (var methodName:String in methods)
			{
				if(objectHasMethod(mediator, methodName))
				{
					return;
				}
			}
			
			throw new IllegalOperationError("None of the selection of expected methods ( " +  methods +  " ) were found on " + mediator);
		}
		
		override protected function startupCallback(mediator:*):void
		{
			mediator.initialize();
		}
	}
}