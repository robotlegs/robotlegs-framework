//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.utils
{
	import robotlegs.bender.framework.api.IMatcher;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function instanceOfType(type:Class):IMatcher
	{
		return new InstanceOfMatcher(type);
	}
}

import robotlegs.bender.framework.api.IMatcher;

class InstanceOfMatcher implements IMatcher
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _type:Class;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	public function InstanceOfMatcher(type:Class)
	{
		_type = type;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	public function matches(item:Object):Boolean
	{
		return item is _type;
	}
}
