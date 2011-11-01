//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.extensions.mediatorMap.configs
{
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	import org.robotlegs.v2.core.api.IContext;
	import org.robotlegs.v2.core.api.IContextConfig;
	import org.robotlegs.v2.core.impl.TypeMatcher;
	import org.robotlegs.v2.core.utilities.checkUIComponentAvailable;
	import org.robotlegs.v2.extensions.mediatorMap.api.IMediatorMap;
	import org.robotlegs.v2.extensions.mediatorMap.utilities.strategies.NoWaitStrategy;
	import org.robotlegs.v2.extensions.mediatorMap.utilities.strategies.WaitForCreationCompleteStrategy;
	import org.robotlegs.v2.extensions.mediatorMap.utilities.triggers.RL2MediatorTrigger;
		
	public class RL2MediatorsStrictConfig implements IContextConfig
	{

		public function configure(context:IContext):void
		{
			const mediatorMap:IMediatorMap = context.injector.getInstance(IMediatorMap);
			const trigger:RL2MediatorTrigger = new RL2MediatorTrigger(true);
			
			if(checkUIComponentAvailable())
			{
				const uiComponentClass:Class = getDefinitionByName('mx.core::UIComponent') as Class;
				trigger.addStartupStrategy(WaitForCreationCompleteStrategy, new TypeMatcher().allOf(uiComponentClass));
				trigger.addStartupStrategy(NoWaitStrategy, new TypeMatcher().noneOf(uiComponentClass));
			}
			else
			{
				trigger.addStartupStrategy(NoWaitStrategy, new TypeMatcher().allOf(DisplayObject));
			}
			
			mediatorMap.loadTrigger(trigger);	
		}
	}
}