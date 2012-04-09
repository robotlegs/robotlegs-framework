//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.localEventMap
{
	import robotlegs.bender.extensions.localEventMap.api.IEventMap;
	import robotlegs.bender.extensions.localEventMap.impl.EventMap;
	import robotlegs.bender.framework.context.api.IContext;
	import robotlegs.bender.framework.context.api.IContextExtension;

	/**
	 * todo: extension description
	 */
	public class LocalEventMapExtension implements IContextExtension
	{

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function extend(context:IContext):void
		{
			context.injector.map(IEventMap).toType(EventMap);
		}
	}
}
