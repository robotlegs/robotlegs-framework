//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.mediatorMap.utilities.triggers
{
	import flash.display.DisplayObject;
	import flash.utils.describeType;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorTrigger;
	import robotlegs.bender.core.utilities.objectHasMethod;
	import flash.errors.IllegalOperationError;
	import robotlegs.bender.core.api.ITypeMatcher;
	import flash.utils.Dictionary;
	import robotlegs.bender.extensions.mediatorMap.utilities.strategies.NoWaitStrategy;
	import robotlegs.bender.core.api.ITypeFilter;
	import robotlegs.bender.extensions.mediatorMap.api.IMediatorStartupStrategy;
	import robotlegs.bender.extensions.mediatorMap.api.IStrategicTrigger;

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