//------------------------------------------------------------------------------
//  Copyright (c) 2011 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted you to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package org.swiftsuspenders.v2.dsl
{

	public interface IFactory
	{
		function process(request:IFactoryRequest):IFactoryResponse;
		// function destroy(request:IFactoryRequest):void;
		// function withProperty(name:String, factory:IFactory):IFactory;
	}
}
