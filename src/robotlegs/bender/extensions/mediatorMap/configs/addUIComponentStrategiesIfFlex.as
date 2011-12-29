package robotlegs.bender.extensions.mediatorMap.configs
{
	import robotlegs.bender.extensions.mediatorMap.api.IStrategicTrigger;
	import flash.display.DisplayObject;
	import flash.utils.getDefinitionByName;
	import robotlegs.bender.core.impl.TypeMatcher;
	import robotlegs.bender.core.utilities.checkUIComponentAvailable;
	import robotlegs.bender.extensions.mediatorMap.utilities.strategies.NoWaitStrategy;
	import robotlegs.bender.extensions.mediatorMap.utilities.strategies.WaitForCreationCompleteStrategy;

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