//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.framework.impl
{
	import flash.system.ApplicationDomain;
	import org.swiftsuspenders.Injector;
	import robotlegs.bender.framework.api.IInjector;

	public class RobotlegsInjector extends Injector implements IInjector
	{

		/*============================================================================*/
		/* Public Properties                                                          */
		/*============================================================================*/

		public function set parent(parentInjector:IInjector):void
		{
			this.parentInjector = parentInjector as RobotlegsInjector;
		}

		public function get parent():IInjector
		{
			return this.parentInjector as RobotlegsInjector;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function createChild(applicationDomain:ApplicationDomain = null):IInjector
		{
			const childInjector:IInjector = new RobotlegsInjector();
			childInjector.applicationDomain = applicationDomain;
			childInjector.parent = this;
			return childInjector;
		}
	}
}
