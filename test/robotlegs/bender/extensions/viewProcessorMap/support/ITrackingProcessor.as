//------------------------------------------------------------------------------
//  Copyright (c) 2009-2013 the original author or authors. All Rights Reserved.
//
//  NOTICE: You are permitted to use, modify, and distribute this file
//  in accordance with the terms of the license agreement accompanying it.
//------------------------------------------------------------------------------

package robotlegs.bender.extensions.viewProcessorMap.support
{
	import robotlegs.bender.framework.api.IInjector;

	public interface ITrackingProcessor
	{
		function process(view:Object, type:Class, injector:IInjector):void;

		function unprocess(view:Object, type:Class, injector:IInjector):void;
	}

}

