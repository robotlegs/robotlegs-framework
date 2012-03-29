//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.logging
{
	import robotlegs.bender.extensions.logging.impl.InjectorListener;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.context.api.IContextExtension;
	import robotlegs.bender.framework.object.managed.impl.ManagedObject;

	public class InjectorLoggingExtension implements IContextExtension
	{

		/*============================================================================*/
		/* Private Properties                                                         */
		/*============================================================================*/

		private var _context:IContext;

		private var _listener:InjectorListener;

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function extend(context:IContext):void
		{
			_context = context;
			_listener = new InjectorListener(context.injector, context.getLogger(this));
			_context.addStateHandler(ManagedObject.POST_DESTROY, handlePostDestroy)
		}

		/*============================================================================*/
		/* Private Functions                                                          */
		/*============================================================================*/

		private function handlePostDestroy():void
		{
			_context.removeStateHandler(ManagedObject.POST_DESTROY, handlePostDestroy);
			_listener.destroy();
		}
	}
}
