package utils
{
	import flash.utils.getDefinitionByName;

	public function checkFlex():Boolean
	{
		var UIComponentClass:Class;
		
		try
		{
			UIComponentClass = getDefinitionByName('mx.core::UIComponent') as Class;
		}
		catch (error:Error)
		{
			// do nothing
		}
		return UIComponentClass != null;
	}

}

