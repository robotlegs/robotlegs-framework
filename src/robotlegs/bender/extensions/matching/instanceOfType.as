//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.matching
{
	import robotlegs.bender.framework.api.IMatcher;

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * Creates a matcher that matches objects of the given type
	 * @param type The type to match
	 * @return A matcher
	 */
	public function instanceOfType(type:Class):IMatcher
	{
		return new InstanceOfMatcher(type);
	}
}

import robotlegs.bender.framework.api.IMatcher;

/**
 * @private
 */
class InstanceOfMatcher implements IMatcher
{

	/*============================================================================*/
	/* Private Properties                                                         */
	/*============================================================================*/

	private var _type:Class;

	/*============================================================================*/
	/* Constructor                                                                */
	/*============================================================================*/

	/**
	 * @private
	 */
	public function InstanceOfMatcher(type:Class)
	{
		_type = type;
	}

	/*============================================================================*/
	/* Public Functions                                                           */
	/*============================================================================*/

	/**
	 * @inheritDoc
	 */
	public function matches(item:*):Boolean
	{
		return item is _type;
	}
}
