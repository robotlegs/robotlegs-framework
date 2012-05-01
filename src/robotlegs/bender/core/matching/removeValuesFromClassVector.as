//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.core.matching
{
	public function removeValuesFromClassVector(values:Array, vector:Vector.<Class>):void
	{
		var type:Class;
		if (values.length == 1)
		{
			if (values[0] is Array)
			{
				values = values[0];
			}
			else if (values[0] is Vector.<Class>)
			{
				const types:Vector.<Class> = values[0];
				values = [];
				for each (type in types)
				{
					values.push(type);
				}
			}
		}
		for each (type in values)
		{
			var index:int = vector.indexOf(type);
			index >= 0 && vector.splice(index, 1);
		}
	}
}
