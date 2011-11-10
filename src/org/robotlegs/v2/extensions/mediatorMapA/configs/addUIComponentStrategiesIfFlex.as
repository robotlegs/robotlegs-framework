package org.robotlegs.v2.extensions.mediatorMapA.configs
{
	import org.robotlegs.v2.extensions.mediatorMapA.api.IStrategicTrigger;
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	import org.robotlegs.v2.core.impl.TypeMatcher;
	import org.robotlegs.v2.core.utilities.checkUIComponentAvailable;
	import org.robotlegs.v2.extensions.mediatorMapA.utilities.strategies.NoWaitStrategy;
	import org.robotlegs.v2.extensions.mediatorMapA.utilities.strategies.WaitForCreationCompleteStrategy;
	
	public function addUIComponentStrategiesIfFlex(trigger:IStrategicTrigger):Boolean
	{
		if(checkUIComponentAvailable())
		{
			const uiComponentClass:Class = getDefinitionByName('mx.core::UIComponent') as Class;
			trigger.addStartupStrategy(WaitForCreationCompleteStrategy, new TypeMatcher().allOf(uiComponentClass));
			trigger.addStartupStrategy(NoWaitStrategy, new TypeMatcher().noneOf(uiComponentClass));
			return true;
		}
		else
		{
			trigger.addStartupStrategy(NoWaitStrategy, new TypeMatcher().allOf(DisplayObject));
			return false;
		}
	}
}