//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.core.utilities
{
	import flash.utils.getDefinitionByName;

	public function checkUIComponentAvailable():Boolean
	{
		if(flexStatusHelper.flexStatus == flexStatusHelper.UNCHECKED)
		{
			try
			{
				const uiComponentClass:Class = getDefinitionByName('mx.core::UIComponent') as Class;
				if(uiComponentClass != null)
					flexStatusHelper.flexStatus = flexStatusHelper.FLEX_FOUND;
			}
			catch (error:Error)
			{
				flexStatusHelper.flexStatus = flexStatusHelper.FLEX_NOT_FOUND;
			}
		}

		return (flexStatusHelper.flexStatus == flexStatusHelper.FLEX_FOUND);
	}

}

class flexStatusHelper
{
	public static const UNCHECKED:uint = 0;
	public static const FLEX_FOUND:uint = 1;
	public static const FLEX_NOT_FOUND:uint = 2;

 	public static var flexStatus:uint;
}

