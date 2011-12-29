//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.core.impl
{
	import flash.utils.getTimer;
	import robotlegs.bender.core.api.IContext;
	import robotlegs.bender.core.api.IContextLogTarget;
	import robotlegs.bender.core.api.IContextLogger;

	/**
	 * Code duplication and magic numbers, but we want the speed
	 */
	public class ContextLogger implements IContextLogger
	{
		private const targets:Vector.<IContextLogTarget> = new Vector.<IContextLogTarget>;

		private var context:IContext;

		private var anyTarget:Boolean;

		public function ContextLogger(context:IContext)
		{
			this.context = context;
		}

		public function debug(source:Object, message:*, parameters:Array = null):void
		{
			anyTarget && log(source, 32, getTimer(), message, parameters);
		}

		public function info(source:Object, message:*, parameters:Array = null):void
		{
			anyTarget && log(source, 16, getTimer(), message, parameters);
		}

		public function warn(source:Object, message:*, parameters:Array = null):void
		{
			anyTarget && log(source, 8, getTimer(), message, parameters);
		}

		public function error(source:Object, message:*, parameters:Array = null):void
		{
			anyTarget && log(source, 4, getTimer(), message, parameters);
		}

		public function fatal(source:Object, message:*, parameters:Array = null):void
		{
			anyTarget && log(source, 2, getTimer(), message, parameters);
		}

		public function addTarget(target:IContextLogTarget):void
		{
			targets.push(target);
			anyTarget = targets.length > 0;
		}

		public function removeTarget(target:IContextLogTarget):void
		{
			const index:int = targets.indexOf(target);
			if (index > -1)
			{
				targets.splice(index, 1);
				anyTarget = targets.length > 0;
			}
		}

		private function log(source:Object, level:uint, timestamp:int, message:*, parameters:Array = null):void
		{
			for each (var target:IContextLogTarget in targets)
			{
				target.log(context, source, level, timestamp, message, parameters);
			}
		}
	}
}
