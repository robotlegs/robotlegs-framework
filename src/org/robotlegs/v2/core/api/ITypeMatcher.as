//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.robotlegs.v2.core.api
{

	public interface ITypeMatcher
	{
		function createTypeFilter():ITypeFilter;

		function allOf(types:Vector.<Class>):ITypeMatcher;

		function anyOf(types:Vector.<Class>):ITypeMatcher;

		function noneOf(types:Vector.<Class>):ITypeMatcher;
		
		function lock():void;
	}
}
