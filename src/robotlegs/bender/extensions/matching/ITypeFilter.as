//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.matching
{

	public interface ITypeFilter
	{
		function get allOfTypes():Vector.<Class>;

		function get anyOfTypes():Vector.<Class>;

		function get descriptor():String;

		function get noneOfTypes():Vector.<Class>;

		function matches(item:*):Boolean;
	}
}
