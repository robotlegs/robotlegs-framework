//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.core.matching
{

	public function pushValuesToClassVector(values:Array, vector:Vector.<Class>):void
	{
		if (values.length == 1
			&& (values[0] is Array || values[0] is Vector.<Class>))
		{
			for each (var type:Class in values[0])
			{
				vector.push(type);
			}
		}
		else
		{
			for each (type in values)
			{
				vector.push(type);
			}
		}
	}
}
