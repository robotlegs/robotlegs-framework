//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.core.utilities
{
	import flash.utils.describeType;

	public function classHasMethod(type:Class, methodName:String):Boolean
	{
		return (describeType(type).factory.method.(@name == methodName).length() == 1);
	}
}
