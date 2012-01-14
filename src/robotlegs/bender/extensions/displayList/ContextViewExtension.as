//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.displayList
{
	import flash.display.DisplayObjectContainer;
	import org.hamcrest.object.instanceOf;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.context.api.IContextConfig;

	/**
	 * <p>This Extension waits for a DisplayObjectContainer to be added as a configuration
	 * and maps that container into the context's injector.</p>
	 *
	 * <p>It should be installed before context initialization.</p>
	 */
	public class ContextViewExtension implements IContextConfig
	{

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/
		
		// todo: accept contextView via constructor and use that if provided
		
		public function configureContext(context:IContext):void
		{
			context.addConfigHandler(
				instanceOf(DisplayObjectContainer),
				function(view:DisplayObjectContainer):void {
					context.injector.map(DisplayObjectContainer).toValue(view);
				});
		}
	}
}
