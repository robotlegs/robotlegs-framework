//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.commandCenter
{
	import robotlegs.bender.extensions.commandCenter.api.ICommandCenter;
	import robotlegs.bender.extensions.commandCenter.impl.CommandCenter;
	import robotlegs.bender.framework.api.IContext;
	import robotlegs.bender.framework.api.IExtension;

	public class CommandCenterExtension implements IExtension
	{

		/*============================================================================*/
		/* Public Functions                                                           */
		/*============================================================================*/

		public function extend(context:IContext):void
		{
			context.injector.map(ICommandCenter).toSingleton(CommandCenter);
			// TODO: Investigate SwiftSuspenders circular dependency handling
			// Place a [PostConstruct] tag above the logger setter
			// in CommandCenter to see what I mean
			context.lifecycle.whenInitializing(function():void {
				const commandCenter:CommandCenter = context.injector.getInstance(ICommandCenter);
				commandCenter.logger = context.getLogger(commandCenter);
			});
		}
	}
}
