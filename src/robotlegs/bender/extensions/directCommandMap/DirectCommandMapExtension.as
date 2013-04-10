//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.directCommandMap
{
	import robotlegs.bender.extensions.directCommandMap.api.IDirectCommandMap;
	import robotlegs.bender.extensions.directCommandMap.impl.DirectCommandMap;
	import robotlegs.bender.extensions.utils.ensureContextUninitialized;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;

	/**
	 * TODO: document
	 */
	public class DirectCommandMapExtension implements IExtension
	{

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		/**
		 * @inheritDoc
		 */
		public function extend(context:IContext):void
		{
			ensureContextUninitialized(context, this);
			context.injector.map(IDirectCommandMap).toType(DirectCommandMap);
		}
	}
}
