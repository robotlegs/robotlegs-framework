//------------------------------------------------------------------------------
//  Copyright (c) 2012 the original author or authors. All Rights Reserved. 
// 
//  NOTICE: You are permitted to use, modify, and distribute this file 
//  in accordance with the terms of the license agreement accompanying it. 
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.dsl
{

	public interface IViewProcessorUnmapper
	{

		function fromProcess(processorClassOrInstance:*):void;

		function fromNoProcess():void;

		function fromInjection():void;

		function fromAll():void;
	}

}
