//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.core.impl
{
	import org.robotlegs.v2.core.api.ITypeFilter;


	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function itemPassesFilter(item:*, typeFilter:ITypeFilter):Boolean
	{
		var allOfTypes:Vector.<Class> = typeFilter.allOfTypes;

		var iLength:uint = allOfTypes.length;
		for (var i:uint = 0; i < iLength; i++)
		{
			if (!(item is allOfTypes[i]))
			{
				return false;
			}
		}

		var noneOfTypes:Vector.<Class> = typeFilter.noneOfTypes;

		iLength = noneOfTypes.length;
		for (i = 0; i < iLength; i++)
		{
			if (item is noneOfTypes[i])
			{
				return false;
			}
		}

		var anyOfTypes:Vector.<Class> = typeFilter.anyOfTypes;

		if (anyOfTypes.length == 0 && (allOfTypes.length > 0 || noneOfTypes.length > 0))
		{
			return true;
		}

		iLength = anyOfTypes.length;
		for (i = 0; i < iLength; i++)
		{
			if (item is anyOfTypes[i])
			{
				return true;
			}
		}

		return false;
	}
}
