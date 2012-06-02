//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.logging.integration
{
	import flash.utils.Dictionary;
	import org.swiftsuspenders.Injector;
	import org.swiftsuspenders.dependencyproviders.DependencyProvider;
	import robotlegs.bender.framework.api.IContext;

	public class LoggerProvider implements DependencyProvider
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _context:IContext;

		/*============================================================================*/
		/* Constructor                                                                */
		/*============================================================================*/

		public function LoggerProvider(context:IContext)
		{
			_context = context;
		}

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function apply(targetType:Class, activeInjector:Injector, injectParameters:Dictionary):Object
		{
			return _context.getLogger(targetType);
		}

		public function destroy():void
		{
		}
	}
}
