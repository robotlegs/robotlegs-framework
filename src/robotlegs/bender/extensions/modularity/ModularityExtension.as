//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.modularity
{
	import robotlegs.bender.core.api.IContext;
	import robotlegs.bender.core.api.IContextExtension;
	import robotlegs.bender.core.api.IContextPreProcessor;
	import robotlegs.bender.extensions.modularity.impl.ParentContextFinder;

	public class ModularityExtension implements IContextExtension, IContextPreProcessor
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private const parentContextFinder:ParentContextFinder = new ParentContextFinder();

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function preProcess(context:IContext, callback:Function):void
		{
			parentContextFinder.preProcess(context, callback);
		}

		public function install(context:IContext):void
		{
		}

		public function initialize():void
		{
		}

		public function uninstall():void
		{
		}
	}
}
