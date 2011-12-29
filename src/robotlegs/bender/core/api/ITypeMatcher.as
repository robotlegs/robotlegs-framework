//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.core.api
{

	public interface ITypeMatcher
	{
		function createTypeFilter():ITypeFilter;

		// TODO: review (why is this in the API? should it not already be locked?)
		function lock():void;
	}
}
